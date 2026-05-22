#!/usr/bin/env node
// =============================================================================
// anonymize.mjs -- Node.js port of anonymize.py (feature-equivalent)
// =============================================================================
// Same CLI shape (scrub / restore / inspect / reset).
// Same map.json format on disk (cross-runtime compatible).
// Same scrub rules (Layer 1 known-entities, Layer 2 regex, Layer 3 proper-noun).
//
// Used when Python isn't installed but Node.js is. See ../SKILL.md.
// =============================================================================

import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const DEFAULT_MAP_DIR  = ".anonymize";
const DEFAULT_MAP_FILE = "map.json";

const SCRIPT_DIR     = path.dirname(new URL(import.meta.url).pathname);
const WHITELIST_PATH = path.join(SCRIPT_DIR, "whitelist.json");
const TICKERS_PATH   = path.join(SCRIPT_DIR, "tickers.json");

function loadJSON(p, fallback) {
    try { return JSON.parse(fs.readFileSync(p, "utf8")); } catch { return fallback; }
}
function saveJSON(p, data) {
    fs.mkdirSync(path.dirname(p), { recursive: true });
    const tmp = p + ".tmp";
    fs.writeFileSync(tmp, JSON.stringify(data, null, 2), "utf8");
    fs.renameSync(tmp, p);
}

function newMap() { return { version: 1, next_index: {}, entries: {} }; }
function loadMap(p) { return loadJSON(p, newMap()); }
function saveMap(p, m) { saveJSON(p, m); }

function allocate(m, kind, hint) {
    const n = (m.next_index[kind] || 0) + 1;
    m.next_index[kind] = n;
    return hint ? `{{${kind}_${n}_${hint}}}` : `{{${kind}_${n}}}`;
}
function getOrCreate(m, real, kind, hint) {
    if (m.entries[real]) return m.entries[real].placeholder;
    const ph = allocate(m, kind, hint);
    m.entries[real] = { placeholder: ph, type: kind, ...(hint ? { hint } : {}) };
    return ph;
}

// --- Patterns (mirror of anonymize.py) ---------------------------------------
const RX = {
    EMAIL:        /\b[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}\b/g,
    PHONE_INTL:   /\+\d{1,3}[\s.\-]?\(?\d{1,4}\)?[\s.\-]?\d{1,4}[\s.\-]?\d{1,9}/g,
    PHONE_NA:     /\(?\b\d{3}\)?[\s.\-]\d{3}[\s.\-]\d{4}\b/g,
    SF_ORG_ID:    /\b00[A-Za-z0-9]{13}(?:[A-Za-z]{3})?\b/g,
    LINKEDIN:     /(?:https?:\/\/)?(?:www\.)?linkedin\.com\/(?:in|company|pub)\/[A-Za-z0-9_\-/]+/gi,
    SLACK_URL:    /https?:\/\/[a-z0-9\-]+\.slack\.com(?:\/[^\s)]*)?/gi,
    SLACK_CHAN:   /#([a-z0-9][a-z0-9_\-]{2,})/g,
    URL:          /https?:\/\/[^\s)>\]]+/gi,
    MONEY_COMMA:  /\$[\d,]{4,}(?:\.\d+)?(?:\s?[KMBkmb])?/g,
    MONEY_SUFFIX: /\$\d+(?:\.\d+)?\s?[KMBkmb](?:i?l)?(?:lion)?\b/g,
    REVENUE:      /\$?\b\d+(?:\.\d+)?\s?[KMBkmb]?\s?(?:ARR|MRR|TCV|ACV|GMV)\b/gi,
    BARE_DOMAIN:  /(?<![A-Za-z0-9._/-])(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+(?:com|org|net|io|co|gov|edu|ai|app|dev|cloud|tech|info|biz|us|uk|ca|au|de|fr|jp|nz)\b(?!\/)/g,
    SSN:          /\b\d{3}-\d{2}-\d{4}\b/g,
    EIN:          /\b\d{2}-\d{7}\b/g,
    AADHAAR:      /\b\d{4}\s?\d{4}\s?\d{4}\b/g,
    UK_NI:        /\b[A-Z]{2}\d{6}[A-Z]\b/g,
    SIN:          /\b\d{3}[\s\-]?\d{3}[\s\-]?\d{3}\b/g,
    CASE_ID:      /\b(?:OCC|FTC|SEC|EEOC|DOL|HHS|CFPB|FDIC|CMS)\s?(?:[A-Z]+\-)?\d{2,4}\-\d+\b/g,
    DATE_ISO:     /\b(?:19|20)\d{2}-(?:0\d|1[012])-(?:0\d|[12]\d|3[01])\b/g,
    DATE_WORD:    /\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s\d{1,2},?\s(?:19|20)\d{2}\b/g,
    DATE_SLASH:   /\b\d{1,2}\/\d{1,2}\/(?:19|20)\d{2}\b/g,
    HEADCOUNT:    /\b(\d{1,3}(?:,\d{3})*)\s?(?:employees?|FTEs?|staff)\b/gi,
    COORDS:       /\b-?\d{1,3}\.\d{4,},\s*-?\d{1,3}\.\d{4,}\b/g,
    TICKER:       /\$?\b[A-Z]{2,5}\b/g,
    PROPER_NOUN:  /\b(?:[A-Z][a-zA-Z]+(?:\s+(?:of|the|and|for|de|du|la|le)\s+|\s+)?){1,4}[A-Z][a-zA-Z&]+\b/g,
};

const COMPANY_MARKERS = new Set([
    "Inc","Inc.","LLC","L.L.C.","Ltd","Ltd.","Limited","Corp","Corp.",
    "Corporation","Company","Co.","Hospital","Health","Bank","Credit","Union",
    "Systems","Group","University","College","Foundation","Authority",
    "District","Trust","Society","Association","Holdings",
]);
const DEFAULT_CHANNELS = new Set(["general","random","announcements","help","introductions"]);
const PUBLIC_HOSTS = new Set([
    "salesforce.com","trailhead.salesforce.com","help.salesforce.com",
    "architect.salesforce.com","developer.salesforce.com",
    "salesforce.stackexchange.com","google.com","bing.com","duckduckgo.com",
    "scholar.google.com","crunchbase.com","linkedin.com","github.com",
    "wikipedia.org","youtube.com",
]);
const BUILTIN_WHITELIST = new Set([
    "Salesforce","Sales Cloud","Service Cloud","Marketing Cloud","Commerce Cloud",
    "Data Cloud","Experience Cloud","Field Service","Revenue Cloud","Agentforce",
    "Einstein","Trust Layer","Hyperforce","Atlas","Tableau","Tableau Pulse",
    "MuleSoft","Anypoint","Slack","Heroku","Apex","Lightning","Flow","Visualforce",
    "Pardot","Trailhead","LWC","Trailblazer","AppExchange","Health Cloud",
    "Life Sciences Cloud","Manufacturing Cloud","Automotive Cloud","Communications Cloud",
    "Consumer Goods Cloud","Education Cloud","Energy & Utilities Cloud",
    "Financial Services Cloud","Media Cloud","Nonprofit Cloud","Public Sector Solutions",
    "Government Cloud","Government Cloud Plus",
    "Microsoft","Microsoft Dynamics","Dynamics 365","HubSpot","ServiceNow",
    "AWS","Amazon Web Services","Google Cloud","GCP","Azure","Oracle","SAP",
    "Workday","Zendesk","Stripe","Twilio","Okta",
    "United States","United Kingdom","European Union","EMEA","APAC","LATAM",
    "North America","South America","Asia","Europe","Africa",
    "Epic","Cerner","MyChart","EHR","EMR","FHIR",
]);
const GENERIC_TITLES = new Set([
    "CEO","COO","CFO","CIO","CTO","CMO","CRO","CISO","CCO","CDO",
    "VP","SVP","EVP","Director","Manager","Lead","Head","Chief","President",
    "Officer","Champion","Buyer","Architect","Engineer","Administrator","Specialist",
    "Solution Engineer","Account Executive","Industry Specialist",
    "Enterprise Architect","Technical Architect","Business Value Consultant",
    "Customer Success Manager",
]);
const PERSON_TITLES = new Set(["Mr.","Mrs.","Ms.","Mx.","Dr.","Prof.","Sen.","Rep.","Sir","Lady","Lord"]);

function loadWhitelist() {
    const ext = loadJSON(WHITELIST_PATH, []);
    return new Set([...BUILTIN_WHITELIST, ...(Array.isArray(ext) ? ext : [])]);
}
function loadTickers() {
    const t = loadJSON(TICKERS_PATH, []);
    return new Set(Array.isArray(t) ? t : []);
}

function applyPattern(text, rx, m, kind, hintFn) {
    return text.replace(rx, (match) => {
        const hint = hintFn ? hintFn(match) : null;
        return getOrCreate(m, match, kind, hint);
    });
}
function magnitudeHint(s) {
    s = s.toUpperCase();
    if (s.includes("B")) return "BIL";
    if (s.includes("M")) return "MIL";
    if (s.includes("K")) return "K";
    return null;
}
function revenueHint(s) {
    s = s.toUpperCase();
    for (const tok of ["ARR","MRR","TCV","ACV","GMV"]) if (s.includes(tok)) return tok;
    return null;
}

export function scrub(text, knownEntities = [], mapPath = null) {
    mapPath = mapPath || path.join(DEFAULT_MAP_DIR, DEFAULT_MAP_FILE);
    const m = loadMap(mapPath);

    // Layer 0: _RAW_ collision sentinel -- swap pre-existing {{...}} tokens
    // already in the input for [[RAW_N]] sentinels so they survive restore()
    // without being rewritten into real entities. Without this, a user who
    // writes a literal {{COMPANY_1}} in their notes would have it silently
    // replaced with whatever COMPANY_1 maps to after a round-trip.
    const rawSeen = new Set();
    const rawTokens = (text.match(/\{\{[A-Z][A-Z0-9_=]*\}\}/g) || []).filter(t => {
        if (rawSeen.has(t)) return false;
        rawSeen.add(t);
        return true;
    });
    for (const rawTok of rawTokens) {
        let sentinel;
        if (rawTok in m.entries) {
            sentinel = m.entries[rawTok].placeholder;
        } else {
            const n = (m.next_index.RAW || 0) + 1;
            m.next_index.RAW = n;
            sentinel = `[[RAW_${n}]]`;
            m.entries[rawTok] = { placeholder: sentinel, type: "RAW" };
        }
        text = text.split(rawTok).join(sentinel);
    }

    // Layer 1: caller-supplied
    for (const ent of knownEntities) {
        if (!ent) continue;
        let kind = "ENTITY";
        if (ent.split(/\s+/).some(w => COMPANY_MARKERS.has(w))) kind = "COMPANY";
        else if (/^[A-Z][a-z]+\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?$/.test(ent)) kind = "PERSON";
        const ph = getOrCreate(m, ent, kind);
        text = text.split(ent).join(ph);
    }

    // Layer 2: regex (order matters)
    text = applyPattern(text, RX.EMAIL,        m, "EMAIL");
    text = applyPattern(text, RX.LINKEDIN,     m, "LINKEDIN");
    text = applyPattern(text, RX.SLACK_URL,    m, "URL");
    text = applyPattern(text, RX.SF_ORG_ID,    m, "ORG_ID");
    text = applyPattern(text, RX.PHONE_INTL,   m, "PHONE");
    text = applyPattern(text, RX.PHONE_NA,     m, "PHONE", () => "NA");
    text = applyPattern(text, RX.SSN,          m, "ID");
    text = applyPattern(text, RX.EIN,          m, "ID");
    text = applyPattern(text, RX.AADHAAR,      m, "ID");
    text = applyPattern(text, RX.UK_NI,        m, "ID");
    text = applyPattern(text, RX.SIN,          m, "ID");
    text = applyPattern(text, RX.REVENUE,      m, "REVENUE", revenueHint);
    text = applyPattern(text, RX.MONEY_SUFFIX, m, "MONEY_USD", magnitudeHint);
    text = applyPattern(text, RX.MONEY_COMMA,  m, "MONEY_USD", magnitudeHint);
    text = applyPattern(text, RX.CASE_ID,      m, "CASE_ID");
    text = applyPattern(text, RX.DATE_ISO,     m, "DATE");
    text = applyPattern(text, RX.DATE_WORD,    m, "DATE");
    text = applyPattern(text, RX.DATE_SLASH,   m, "DATE");
    text = applyPattern(text, RX.COORDS,       m, "COORDS");

    // Headcount: preserve round buckets
    const ROUND = new Set([1,25,100,250,500,1000,2500,5000,10000,25000,50000,100000]);
    text = text.replace(RX.HEADCOUNT, (match, num) => {
        const n = parseInt(num.replace(/,/g, ""), 10);
        if (ROUND.has(n)) return match;
        const noun = match.slice(num.length).trimStart();
        return getOrCreate(m, num, "HEADCOUNT") + " " + noun;
    });

    // Slack channels with custom prefix
    text = text.replace(RX.SLACK_CHAN, (match, name) => {
        if (DEFAULT_CHANNELS.has(name.toLowerCase())) return match;
        return getOrCreate(m, match, "SLACK_CHANNEL");
    });

    // Generic URL: scrub if host not whitelisted
    text = text.replace(RX.URL, (url) => {
        const h = (url.match(/^https?:\/\/([^\/\s)]+)/i) || [])[1] || "";
        const host = h.toLowerCase().startsWith("www.") ? h.slice(4) : h.toLowerCase();
        for (const ph of PUBLIC_HOSTS) if (host === ph || host.endsWith("." + ph)) return url;
        return getOrCreate(m, url, "URL");
    });

    // Bare domain (no scheme): aggressive-by-default privacy doctrine.
    text = text.replace(RX.BARE_DOMAIN, (match) => {
        const host = match.toLowerCase();
        const hostNoWww = host.startsWith("www.") ? host.slice(4) : host;
        for (const ph of PUBLIC_HOSTS) if (hostNoWww === ph || hostNoWww.endsWith("." + ph)) return match;
        return getOrCreate(m, match, "DOMAIN");
    });

    // Stock tickers (whitelist-filtered)
    const tickers = loadTickers();
    text = text.replace(RX.TICKER, (tok) => {
        if (tickers.has(tok.replace(/^\$/, "").toUpperCase())) return getOrCreate(m, tok, "TICKER");
        return tok;
    });

    // Layer 3: heuristic proper-noun detection
    const whitelist = loadWhitelist();
    const LEADING_DETERMINERS = new Set([
        "The","Their","Our","His","Her","Its","My","Your","A","An",
        "This","That","These","Those",
    ]);
    const GENERIC_TWO_WORD = new Set([
        "Account ID","Account Number","Account Name","Account Owner",
        "Case ID","Case Number","Order ID","Order Number",
        "Opportunity ID","Opportunity Name","Record ID","Object Name",
        "Profile Name","Role Name","Field Name","Tab Name",
        "User ID","User Name","Group Name",
    ]);
    text = text.replace(RX.PROPER_NOUN, (phrase) => {
        if (phrase.includes("{{") || phrase.includes("}}") || phrase.includes("[[")) return phrase;
        if (whitelist.has(phrase) || GENERIC_TITLES.has(phrase) || GENERIC_TWO_WORD.has(phrase)) return phrase;
        let words = phrase.split(/\s+/);
        // Strip a leading determiner.
        let leading = "";
        if (words.length && LEADING_DETERMINERS.has(words[0])) {
            leading = words[0] + " ";
            words = words.slice(1);
        }
        if (!words.length) return phrase;
        // Role-hint extraction: "CISO Jane Roe" -> "{{PERSON_1_ROLE=CISO}}".
        if (GENERIC_TITLES.has(words[0]) && words.length >= 2 &&
            /^[A-Z][a-z]+$/.test(words[1])) {
            const personWords = (words.length >= 3 && /^[A-Z][a-z]+$/.test(words[2]))
                ? words.slice(1, 3) : words.slice(1, 2);
            const personPhrase = personWords.join(" ");
            const ph = getOrCreate(m, personPhrase, "PERSON", "ROLE=" + words[0].toUpperCase());
            const tail = words.slice(1 + personWords.length).join(" ");
            return `${leading}${words[0]} ${ph}${tail ? " " + tail : ""}`;
        }
        const capWords = words.filter(w => w && w[0] >= "A" && w[0] <= "Z");
        if (capWords.length < 2) return phrase;
        const joined = words.join(" ");
        let kind = "ENTITY";
        for (const marker of COMPANY_MARKERS) {
            if (joined.includes(marker)) { kind = "COMPANY"; break; }
        }
        if (PERSON_TITLES.has(words[0]) ||
            (words.length === 2 && words.every(w => /^[A-Z][a-z]+$/.test(w)))) {
            kind = "PERSON";
        }
        return `${leading}${getOrCreate(m, joined, kind)}`;
    });

    saveMap(mapPath, m);
    return { text, entries: m.entries };
}

export function restore(text, mapPath = null) {
    mapPath = mapPath || path.join(DEFAULT_MAP_DIR, DEFAULT_MAP_FILE);
    const m = loadMap(mapPath);
    const reverse = {};
    for (const [real, info] of Object.entries(m.entries)) reverse[info.placeholder] = real;

    const found = new Set((text.match(/\{\{[A-Z][A-Z0-9_=]*\}\}/g) || []));
    // RAW sentinels use [[RAW_N]] -- exclude them from the unknown check.
    const normal = {};
    const raw = {};
    for (const [ph, real] of Object.entries(reverse)) {
        if (ph.startsWith("[[")) raw[ph] = real; else normal[ph] = real;
    }
    const unknown = [...found].filter(ph => !(ph in normal)).sort();

    // Substitute normal placeholders first, longest-first.
    for (const ph of Object.keys(normal).sort((a,b)=>b.length-a.length)) {
        text = text.split(ph).join(normal[ph]);
    }
    // RAW sentinels restore LAST so the literal {{X}} they produce doesn't
    // re-trigger a normal placeholder substitution.
    for (const ph of Object.keys(raw).sort((a,b)=>b.length-a.length)) {
        text = text.split(ph).join(raw[ph]);
    }
    return { text, unknown };
}

function summarize(entries) {
    const counts = {};
    for (const info of Object.values(entries)) counts[info.type] = (counts[info.type] || 0) + 1;
    if (Object.keys(counts).length === 0) return "anonymize: scrubbed 0 entities";
    const parts = Object.entries(counts).sort((a,b)=>b[1]-a[1]).map(([k,n]) => `${n} ${k}`).join(", ");
    const total = Object.values(counts).reduce((a,b)=>a+b, 0);
    return `anonymize: scrubbed ${total} entities -- ${parts}`;
}

async function readStdin() {
    let data = "";
    process.stdin.setEncoding("utf8");
    for await (const chunk of process.stdin) data += chunk;
    return data;
}

async function readInput(args) {
    if (args.input === "-" || (!args.input && !process.stdin.isTTY)) return await readStdin();
    if (args.input) return fs.readFileSync(args.input, "utf8");
    return null;
}

function parseArgs(argv) {
    const out = { cmd: null, scrub: [], input: null, output: null, map: null };
    if (argv.length === 0) return out;
    out.cmd = argv[0];
    for (let i = 1; i < argv.length; i++) {
        const a = argv[i];
        if (a === "--input") out.input = argv[++i];
        else if (a === "--output") out.output = argv[++i];
        else if (a === "--map") out.map = argv[++i];
        else if (a === "--scrub") out.scrub.push(argv[++i]);
    }
    return out;
}

async function main() {
    const args = parseArgs(process.argv.slice(2));
    if (!args.cmd || ["help","--help","-h","?"].includes(args.cmd)) {
        process.stderr.write("usage: node anonymize.mjs {scrub|restore|inspect|reset} [--input <f>] [--output <f>] [--map <f>] [--scrub <ent>]\n");
        process.exit(args.cmd ? 0 : 1);
    }
    const mapPath = args.map || path.join(DEFAULT_MAP_DIR, DEFAULT_MAP_FILE);
    if (args.cmd === "scrub") {
        const text = await readInput(args);
        if (text === null) { process.stderr.write("error: no input. Pass --input <file>, '-' for stdin, or pipe.\n"); process.exit(1); }
        const { text: out, entries } = scrub(text, args.scrub, mapPath);
        if (args.output) fs.writeFileSync(args.output, out, "utf8"); else process.stdout.write(out);
        process.stderr.write(summarize(entries) + "\n");
    } else if (args.cmd === "restore") {
        const text = await readInput(args);
        if (text === null) { process.stderr.write("error: no input.\n"); process.exit(1); }
        const { text: out, unknown } = restore(text, mapPath);
        if (args.output) fs.writeFileSync(args.output, out, "utf8"); else process.stdout.write(out);
        if (unknown.length) process.stderr.write(`anonymize: ${unknown.length} unknown placeholder(s) left in place: ${unknown.slice(0,10).join(", ")}${unknown.length>10?"...":""}\n`);
    } else if (args.cmd === "inspect") {
        if (!fs.existsSync(mapPath)) { console.log(`No map at ${mapPath} -- nothing scrubbed yet.`); return; }
        const m = loadMap(mapPath);
        console.log(`Map: ${mapPath}`);
        console.log(`Entries: ${Object.keys(m.entries).length}\n`);
        console.log("Placeholder                         Type           Real value");
        console.log("-".repeat(80));
        const rows = Object.entries(m.entries).sort((a,b) => a[1].placeholder.localeCompare(b[1].placeholder));
        for (const [real, info] of rows) {
            const display = real.length <= 30 ? real : real.slice(0,27) + "...";
            console.log(`${info.placeholder.padEnd(35)} ${info.type.padEnd(14)} ${display}`);
        }
    } else if (args.cmd === "reset") {
        if (fs.existsSync(mapPath)) { fs.unlinkSync(mapPath); console.log(`Removed ${mapPath}`); }
        else { console.log(`No map at ${mapPath} -- already clean.`); }
    } else {
        process.stderr.write(`unknown subcommand: ${args.cmd}\n`);
        process.exit(1);
    }
}

main().catch(e => { process.stderr.write(`anonymize error: ${e.message}\n`); process.exit(1); });
