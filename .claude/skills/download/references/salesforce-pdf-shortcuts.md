# Salesforce Documentation PDF Shortcuts

Many Salesforce documentation sets ship a single PDF that contains the entire
guide. These are authoritative, version-pinned, and far more efficient to
download than crawling hundreds of HTML pages. **Always prefer a PDF shortcut
when one exists for the topic.**

## How to find the PDF for any doc set

Salesforce ships 3 major releases per year. Release numbers in PDF URLs
change with each release, so **never hardcode a release number**. Instead:

1. Fetch the HTML entry point for the doc set (e.g., a chapter page on
   `developer.salesforce.com/docs/` or `help.salesforce.com/s/`).
2. Parse the page for a "Download PDF" link or a link matching
   `resources.docs.salesforce.com/.../pdf/...` — these are typically in the
   page footer or a sidebar nav element.
3. Download that resolved PDF URL directly.

The PDF URL pattern is typically:
```
https://resources.docs.salesforce.com/<release>/latest/en-us/sfdc/pdf/<guide_name>.pdf
```
Where `<release>` is the current API version (changes 3x/year — e.g., 262,
263, 264). **Always resolve this from the live page, never assume the number.**

## Known doc sets with PDF versions (high-value for /focus-group accuracy)

The PDF URLs below are **examples from one release** — always resolve the
current PDF link from the HTML entry point (see "How /download should use
this" above). The HTML entry points are stable across releases.

### Developer / Platform

| Doc set | HTML entry point (stable) | Example PDF path (resolve from page) |
|---------|--------------------------|--------------------------------------|
| Apex Developer Guide | developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_dev_guide.htm | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_apex_developer_guide.pdf |
| Lightning Web Components Dev Guide | developer.salesforce.com/docs/platform/lwc/guide | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/lwc_dev_guide.pdf |
| SOQL & SOSL Reference | developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_soql_sosl.pdf |
| REST API Developer Guide | developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_rest_api.pdf |
| Metadata API Developer Guide | developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_metadata_api.pdf |
| Platform Events Developer Guide | developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/platform_events.pdf |
| Bulk API 2.0 Developer Guide | developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_bulk_api_2.pdf |

### Admin / Configuration

| Doc set | HTML entry point (stable) | Example PDF path (resolve from page) |
|---------|--------------------------|--------------------------------------|
| Salesforce Help (Object Reference) | help.salesforce.com/s/articleView?id=sf.basics_object_reference.htm | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_object_reference.pdf |
| Security Implementation Guide | developer.salesforce.com/docs/atlas.en-us.securityImplGuide.meta/securityImplGuide/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_security_impl_guide.pdf |
| Sharing & Visibility Designer Guide | help.salesforce.com/s/articleView?id=sf.security_data_access.htm | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_record_access_under_the_hood.pdf |
| Limits Quick Reference | developer.salesforce.com/docs/atlas.en-us.salesforce_app_limits_cheatsheet.meta/salesforce_app_limits_cheatsheet/ | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/salesforce_app_limits_cheatsheet.pdf |

### AI / Agentforce / Einstein

| Doc set | HTML entry point (stable) | Example PDF path (resolve from page) |
|---------|--------------------------|--------------------------------------|
| Einstein AI (Salesforce Help) | help.salesforce.com/s/articleView?id=sf.generative_ai_overview.htm | (check page footer — may be part of a broader "AI" PDF) |
| Agentforce Setup Guide | help.salesforce.com/s/articleView?id=sf.copilot_setup.htm | (check page footer — evolving rapidly; verify release) |

### Data Cloud

| Doc set | HTML entry point (stable) | Example PDF path (resolve from page) |
|---------|--------------------------|--------------------------------------|
| Data Cloud Admin Guide | help.salesforce.com/s/articleView?id=sf.c360_a_background.htm | (check page footer — verify latest release PDF exists) |

### Industry Clouds

| Doc set | HTML entry point (stable) | Example PDF path (resolve from page) |
|---------|--------------------------|--------------------------------------|
| Health Cloud Implementation | help.salesforce.com/s/articleView?id=sf.admin_health_cloud.htm | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/health_cloud_impl_guide.pdf |
| Financial Services Cloud | help.salesforce.com/s/articleView?id=sf.fsc_admin.htm | resources.docs.salesforce.com/262/latest/en-us/sfdc/pdf/financial_services_cloud_admin_guide.pdf |
| Manufacturing Cloud | help.salesforce.com/s/articleView?id=sf.manufacturing_cloud.htm | (check page footer) |
| Education Cloud | help.salesforce.com/s/articleView?id=sf.education_cloud.htm | (check page footer) |
| Nonprofit Cloud | help.salesforce.com/s/articleView?id=sf.nonprofit_cloud.htm | (check page footer) |

## Product overview hub

The master product listing with links into each doc set:
- **https://help.salesforce.com/s/products**

From here you can navigate to any product's documentation, and each typically
links to its PDF version at the page footer.

## How /download should use this

When the topic maps to a known doc set in this table:
1. **Fetch the HTML entry point first** — even when a PDF URL is listed in
   the table below. The table URLs are examples from one release; the live
   page has the current release's PDF link.
2. **Parse the PDF link from the page** — look for `resources.docs.salesforce.com`
   links in the footer, sidebar, or a "Download PDF" element.
3. **Download the resolved PDF** — one shot, entire guide, authoritative.
4. If no PDF link is found on the page, fall back to rendering the HTML
   content directly (the doc set may not ship a PDF, or the format changed).

Never cache or hardcode PDF URLs across sessions — the release number changes
3x/year and stale URLs will 404.

## How /focus-group Step 7 should use this

When auto-researching a topic that involves Salesforce platform claims
(governor limits, API behavior, sharing model, feature GA status):
1. Check this table for a matching doc set.
2. Download the PDF to `references/<slug>/`.
3. The accuracy rubric's "Platform-fact verification" factor (weight 20) will
   score higher when claims can be verified against downloaded doc content.
