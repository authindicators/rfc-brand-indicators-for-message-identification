---
title: Brand Indicators for Message Identification (BIMI)
docname: draft-brand-indicators-for-message-identification-latest
date: 2017-03-18
category: info

workgroup: Authindicators Working Group
keyword: Internet-Draft

normative:
  ABNF:
    target: http://www.rfc-editor.org/info/rfc5234
    title: "Augmented BNF for Syntax Specifications: ABNF"
    author:
      ins: Crocker, D., Ed., and P. Overell
    date: January 2008
  KEYWORDS:
    target: http://www.rfc-editor.org/info/rfc2119
    title: Key words for use in RFCs to Indicate Requirement Levels
    author:
      ins: Bradner, S.
    date: March 1997
  EMAIL-ARCH:
    target: http://www.rfc-editor.org/info/rfc5598
    title: Internet Mail Architecture
    author:
      ins: Crocker, D.
    date: July 2009
  DNS:
    target: http://www.rfc-editor.org/info/rfc1035
    title: Domain names - implementation and specification
    author:
      ins: Mockapetris, P.
    date: November 1987
  DKIM:
    target: http://www.rfc-editor.org/info/rfc6376
    title: DomainKeys Identified Mail (DKIM) Signatures
    author:
      ins: Crocker, D., Ed., Hansen, T., Ed., and M. Kucherawy, Ed.
    date: September 2011
  SPF:
    target: http://www.rfc-editor.org/info/rfc7208
    title: Sender Policy Framework (SPF) for Authorizing Use of Domains in Email, Version 1
    author:
      ins: Kitterman, S.
    date: April 2014
  DMARC:
    target: http://www.rfc-editor.org/info/rfc7489
    title: Domain-based Message Authentication, Reporting, and Conformance (DMARC)
    author:
      ins: Kucherawy, M., Ed. and E. Zwicky, Ed.
    date: March 2015
  SMTP:
    target: http://www.rfc-editor.org/info/rfc5321
    title: Simple Mail Transfer Protocol
    author:
      ins: Klensin, J.
    date: October 2008
  URI:
    target: http://www.rfc-editor.org/info/rfc3986
    title: "Uniform Resource Identifier (URI): Generic Syntax"
    author:
      ins: Berners-Lee, T., Fielding, R., and L. Masinter
    date: January 2005
  Authentication-Results:
    target: https://tools.ietf.org/html/rfc7601
    title: Message Header Field for Indicating Message Authentication Status
    author:
      ins: Kucherawy, M.
    date: August 2015

stand_alone: yes
pi: [toc, sortrefs, symrefs]

author:
 -
    ins: T. Loder
    name: Thede Loder
    organization: Agari
    email: tloder@agari.com
 -
    ins: T. Zink
    name: Terry Zink
    organization: Microsoft
    email: tzink@exchange.microsoft.com
 -
    ins: P. Goldstein
    name: Peter Goldstein
    organization: ValiMail
    email: peter@valimail.com
 -
    ins: S. Blank
    name: Seth Blank
    organization: ValiMail
    email: seth@valimail.com

--- abstract

Brand Indicators for Message Identification (BIMI) permits Domain Owners to coordinate with Mail User Agents (MUAs) to display brand-specific indicators next to properly authenticated messages.  There are two aspects of BIMI coordination: a scalable mechanism for Domain Owners to publish their desired indicators, and a mechanism for Mail Transfer Agents (MTAs) to verify the authenticity and reputation of the domain.  This document specifies how Domain Owners communicate their desired indicators through the BIMI assertion record in [DNS] and how that record is to be handled by MTAs and MUAs.  The domain verification mechanism and extensions for other mail protocols (IMAP, etc.) are specified in separate documents.  By itself BIMI does not impose specific requirements for indicator display on MUAs.  BIMI is just a mechanism to support coordination between mail-originating organizations and MUAs.  MUAs and mail-receiving organizations are free to define their own policies for indicator display that makes use or not of BIMI data as they see fit.

--- middle

Introduction        {#problems}
============

This document defines Brand Indicators for Message Identification (BIMI), which permits Domain Owners to coordinate with Mail User Agents (MUAs) to display brand-specific indicators next to properly authenticated messages.

Due to the amount of spam and forged email on the internet today, many mail receivers wish to benefit their users by clearly identifying authenticated email.  For email-sending organizations, the belief is that clear indicators of their brand is the most effective way to accomplish this.  This has in turn led receivers to build closed systems to manage brand indicators.

BIMI is an open system that works at internet scale, so that Domain Owners can coordinate with MUAs to display appropriate indicators.  BIMI has the added benefit of incentivizing Domain Owners to authenticate their email.

The approach taken by BIMI is nearly identical to the approach taken by [DKIM](https://tools.ietf.org/html/rfc6376#section-1), in that BIMI:

* has no dependency on the deployment of any new Internet protocols or services for indicator registration or revocation;
* makes no attempt to include encryption as part of the mechanism;
* is compatible with the existing email infrastructure and transparent to the fullest extent possible;
* requires minimal new infrastructure;
* can be implemented independently of clients in order to reduce deployment time;
* can be deployed incrementally; and
* allows delegation of indicator hosting to third parties.

This document covers the BIMI mechanism for Domain Owners to publish their desired indicators and how Mail Transfer Agents (MTAs) and MUAs should handle this communication.  This document does not cover how domains are verified, how MUAs should display the indicators, or how other protocols (i.e. IMAP) should be extended to work with BIMI.  Other documents will cover these topics.

Why BIMI        {#why-bimi}
============

Email Authentication     {#emailauth}
-------------

The Sender Policy Framework ([SPF]), DomainKeys Identified Mail ([DKIM]), and Domain-based Message Authentication, Reporting, and Conformance ([DMARC]) provide mechanisms for domain-level authentication for email messages.  They enable cooperating email senders and receivers to distinguish messages that are authorized to use the domain name from those that are not.  Given that not all senders employ these authentication mechanisms, many Mail User Agents (MUAs) make attempts to indicate to their end users when particular messages are in fact authenticated.

Generic Indication of Authenticity     {#genericauth}
-------------

It is currently possible for MUAs to indicate the validity of messages authenticated via [these mechanisms](#emailauth) through the use of generic visual indicators such as checkmarks if authenticated or questions marks otherwise.  But there is a belief that the effectiveness of such generic indicators is limited, and that end users are better served through the use of brand indicators associated with the authenticated sender of the message.

Brand Specific Indication of Authenticity      {#brandauth}
-------------

To benefit their users, MUAs need to be able to effectively and meaningfully convey that messages being displayed are both authenticated and originate from a known organization.  Brand-specific indicators are believed to be a more effective method of communicating message authenticity to end users.  Thus there is a need for MUAs to have access to brand-specific imagery for a very large number of brands.

The Need for Standardization   {#need}
----------------------------

Due to this need for [brand specific indicators](#brandauth), some mail-receiving organizations have developed closed systems for displaying brand indicators for some select domains.  While this enabled these mail-receiving organizations to display brand indicators for a limited subset of messages, this closed approach has significant downsides:

1. It puts a significant burden on each mail-receiving organization, because they must identify and manage a large database of brand indicators.
2. Scalability is challenging for closed systems that attempt to capture and maintain complete sets of data across the whole of the Internet.
3. A lack of uniformity across different mail-receiving organizations - each organization will have its own indicator set, which may or may not agree with those maintained by other organizations for any given domain.
4. Domain Owners have limited ability to influence the brand indicator for the domain(s) they own, and such ability they do have is likely to require coordination with many mail-receiving organizations.
5. MUAs that are not associated with a particular mail-receiving organization are likely to be disadvantaged, because they are unlikely to receive indicators in a manner optimized for their user interfaces.

This all speaks to the need for a standardized mechanism by which Domain Owners can publish and distribute brand indicators for use by any participating MUA.

Indicator Curation     {#curation}
-------------

Domain Owners have an interest in ensuring that the imagery displayed in these situations is correct and appropriate, so it is desirable to provide a mechanism to allow these mail-originating organizations to provide imagery to MUAs.  This mechanism removes the substantial burden of curating and maintaining an image database from the MUAs, and allows each brand to manage its own imagery.  As an additional benefit, mail-originating organizations are more likely to invest the time and effort to authenticate their email, should that come with the ability to influence how email from the organization is displayed.

Requirements   {#requirements}
========================

Specification of BIMI in this document is guided by the following high-level goals, security dependencies, detailed requirements, and items that are documented as out of scope.

High-Level Goals    {#goals}
-----------------

BIMI has the following high-level goals:

* Enable the authors of MUAs to display meaningful imagery associated with the Domain Owner to recipients of authenticated email.
* Allow Domain Owners to suggest appropriate images for display with authenticated messages originating from their domains.
* Provide mechanisms to prevent attempts by malicious Domain Owners to fraudulently represent messages from their domains as originating with other entities.
* Work at Internet Scale.

Security     {#security}
------------

Brand indicators are a potential vector for abuse.  BIMI creates a relationship between sending organization and Mail Receiver so that the receiver can display appropriately designated indicators if the sending domain is verified and has meaningful reputation with the receiver.  Without verification and reputation, there is no way to prevent a bad actor exxample.com from using example.com's brand indicators and behaving in a malicious manner.  This document does not cover these verification and reputation mechanisms, but BIMI requires them to control abuse.

Scalability     {#scalability}
------------

Scalability is a major issue for systems that need to operate in a system as widely deployed as current SMTP email.  For this reason, BIMI seeks to avoid the need for pre-sending agreements between senders and receivers.  This preserves the positive aspects of the current email infrastructure.

Out of Scope     {#out-of-scope}
-------------

Several topics and issues are specifically out of scope for the initial version of this work.  These include the following:

* Defining what consitutes authenticated email for the purposes of this standard.
* Publishing policy other than via the DNS.
* Specific requirements for indicator display on MUAs.
* How receivers should use reputation to influence the display of BIMI indicators.
* The explicit mechanisms used by Verifying Protocol Clients - this will be deferred to a later document.

Outline   {#outline}
----------------------------

The basic outline of BIMI is as follows:

1. Domain Owners publish brand indicator assertions for domains via the [DNS].
2. Receivers authenticate the messages using [DMARC] and/or whatever other authentication mechanisms they wish to apply.
3. If the message authenticates, the receiver queries the DNS for a corresponding BIMI record.
4. If a BIMI record is present, then the receiver adds a header to the message, which can be used by the MUA to determine the Domain Owner's preferred brand indicator.
5. The MUA retrieves and displays the brand indicator as appropriate based on its policy and user interface.

Terminology and Definitions   {#terminology}
========================

This section defines terms used in the rest of the document.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{KEYWORDS}}.

Readers are encouraged to be familiar with the contents of [EMAIL-ARCH].  In particular, that document defines various roles in the messaging infrastructure that can appear the same or separate in various contexts.  For example, a Domain Owner could, via the messaging mechanisms on which BIMI is based, delegate control over defining preferred brand indicators as the Domain Owner to a third party with another role.  This document does not address the distinctions among such roles; the reader is encouraged to become familiar with that material before continuing.


Author Domain
-------------

The domain name of the apparent author, as extracted from the RFC5322.From field.

Assertion Record
-------------

The BIMI preferences stored in DNS TXT records as defined in [Section 6.1](#assertion-record-def).

BIMI Assertion
-------------

The mechanism through which a Protocol Client verifies the BIMI Assertion Record and constructs the URI to the requested indicator or indictaors.

Domain Owner
-------------

An entity or organization that owns a DNS domain.  The term "owns" here indicates that the entity or organization being referenced holds the registration of that DNS domain.  Domain Owners range from complex, globally distributed organizations, to service providers working on behalf of non-technical clients, to individuals responsible for maintaining personal domains.  This specification uses this term as analogous to an Administrative Management Domain as defined in [EMAIL-ARCH].

Mail Receiver
-------------

The entity or organization that receives and processes email.  Mail Receivers operate one or more Internet-facing Mail Transport Agents (MTAs).

Mark Asserting Entity (MAE)
-------------

A Domain Owner who publishes information via the protocol to facilitate distribution of its graphical icons or marks in association with messages for which the domain they "own" is the Author Domain.

Mark Verifying Authority (MVA)
-------------

An entity of organization that can provide evidence of verification of marks asserted by an MAE to Verifying Protocol Clients.  The MVA may choose to uphold and confirm the meeting of certain mark standards (ie. size, trademark, content, etc).

Mail User Agent (MUA)
-------------

An endpoint client that a user (a real human being) uses to access their and read their email.

Protocol Client
-------------

An entity that uses the protocol to discover and fetch published icons or marks.

Verifying Protocol Client
-------------

A Protocol Client that uses the optional verification capability to inquire about the verification status of published marks.

Overview   {#overview}
========================

This section provides a general overview of the design and operation of the BIMI environment.

For Domain Owners   {#for-domain-owners}
-------------

BIMI requires Domain Owners to publish several records to communicate indicators they wish MUAs to use.

### Assertion Record   {#assertion-overview}

An Assertion Record is a DNS TXT record that a Domain Owner publishes to advertise participation in BIMI.

### Selectors    {#selector-overview}

Selectors allows Domain Owners to support multiple indicators per domain.

For Mail Receivers   {#for-mail-receivers}
-------------

BIMI suggests that Mail Receivers and their MTAs add or modify several headers.

### Authentication-Results Header    {#bimi-ar-header}

The status of a BIMI determination SHOULD be added to the Authentication-Results header.

### BIMI-Location Header   {#bimi-location}

Upon a successful authentication check and indicator lookup, the MTA should add the appropriate indicator(s) to the BIMI-Location header so that the MUA can apply minimal logic to display the appropriate indicator.


Policy {#policy}
===================

BIMI policies are published by Domain Owners and applied by Protocol Clients.

A Domain Owner advertises BIMI participation of one or more of its domains by adding a DNS TXT record to those domains.  In doing so, Domain Owners make specific requests of Mail User Agents regarding the preferred set of icons to be displayed with messages purporting to be from one of the Domain Owner's domains.

A Domain Owner may choose not to participate in BIMI.  In this case, the Domain Owner simply declines to advertise participation by not publishing any BIMI assertion record.

A Mail User Agent implementing the BIMI mechanism SHOULD make a best-effort attempt to adhere to the Domain Owner's published BIMI policy.  But Mail User Agents have final control over the user interface published to their end users, and MAY use alternate indicators than those specified in the BIMI assertion record or no indicator at all.

Assertion Record {#assertion-record-def}
-----------------

All Domain Owner BIMI preferences are stored as DNS TXT records in subdomains named "_bimi".  BIMI allows the definition of multiple preferences associated with a single RFC5322.From domain.  To distinguish between these different preferences, BIMI uses selectors. Senders advertise which selector to use by specifying it in a BIMI-Selector header (see below).

For example, the Domain Owner of "example.com" would post BIMI preferences in a TXT record at "default._bimi.example.com".  Similarly, a Mail Receiver wishing to query for BIMI preferences regarding mail with an RFC5322.From domain of "example.com" and a selector "default" would issue a TXT query to the DNS for the subdomain of "default._bimi.example.com".  The DNS-located BIMI preference data will hereafter be called the "BIMI assertion record".

BIMI's use of the DNS is driven by BIMI's use of domain names and the nature of the query it performs. Use of the DNS as the query service has the benefit of reusing an extremely well-established operations, administration, and management infrastructure, rather than creating a new one.

Per [DNS], a TXT record can comprise several "character-string" objects.  Where this is the case, the module performing BIMI Assertion MUST concatenate these strings by joining together the objects in order and parsing the result as a single string.

Selectors   {#selectors}
------------------------

To support multiple brand indicators per domain, the brand indicator namespace is subdivided using "selectors".  Selectors allow the Domain Owner to better target the brand indicator by type of recipient, message source, or other considerations like seasonal branding.  BIMI selectors are modeled after DKIM selectors.

Periods are allowed in selectors and are component separators.  When BIMI assertion records are retrieved from the DNS, periods in selectors define DNS label boundaries in a manner similar to the conventional use in domain names.  In a DNS implementation, this can be used to allow delegation of a portion of the selector namespace.

[ABNF]:

selector =   sub-domain *( "." sub-domain )
             ; from [SMTP] Domain,
             ; excluding address-literal

The number of selectors for each domain is determined by the Domain Owner.  Many Domain Owners will be satisfied with just one selector, whereas organizations with more complex branding requirements can choose to manage disparate selectors.  BIMI sets no maximum limit on the number of selectors.

BIMI supports the notion of a "default" selector.

Extracting the BIMI Selector {#bimi-selector}
----------------------

BIMI DNS records are placed in \<selector\>._bimi.\<domain\>, and by default they are placed in default._bimi.\<domain\>. That is, for example.com, the default location for all BIMI lookups is default._bimi.example.com. However, a Domain Owner may specify the selector using the RFC 5322 header 'BIMI-Selector'. The BIMI-Selector header consists of key value pairs:

v: Version (plain-text; REQUIRED). The version of BIMI, acceptable value is BIMIx, where 'x' is a digit ranging from 0-9. This field is not case-sensitive.

s: Selector (plain-text; REQUIRED). The location of the BIMI DNS record, when combined with the 'd' key value pair.

The BIMI-Selector header SHOULD be DKIM-signed.

The following are brief examples on BIMI record discovery, see #indicator_discovery for full description.

Example 1 - The domain example.com does not send with a BIMI-Selector header. The MTA would lookup default._bimi.example.com for the BIMI DNS record.

From: sender@example.com

Example 2 - The domain example.com sends with a BIMI-Selector header:

From: sender@example.com
BIMI-Selector: v=bimi1; s=selector;

The MTA would lookup selector._bimi.example.com.

Example 4 - The domain example.com sends with a BIMI-Selector header, but does not include the required field 'v=':

From: sender@example.com
BIMI-Selector: s=selector;

The MTA would ignore this header, and lookup default._bimi.example.example.

In Example 2 and Example 3, the BIMI-Selector SHOULD be signed by DKIM, or it MAY be sufficient if the message passes SPF/DMARC alignment. Some MTAs will require DKIM/DMARC alignment, while others will only require SPF/DMARC alignment. Some receivers will require the domain to publish a DMARC record of p=quarantine or p=reject, while some receivers may only require alignment, absent a strong DMARC policy.


General Record Format {#general-record-format}
----------------------

BIMI assertion records follow the extensible "tag-value" syntax for DNS-based key records defined in DKIM [DKIM].

This section creates a registry for known BIMI tags and registers the initial set defined in this document.  Only tags defined in this document or in later extensions, and thus added to that registry, are to be processed; unknown tags MUST be ignored.

The following tags are introduced as the initial valid BIMI tags:

a: Trust Authorities (plain-text; OPTIONAL).  A reserved value.

f: Supported Image Formats (comma-separated plain-text list of values; OPTIONAL; default is "png").  Comma-separated list of three or four character filename extensions denoting the available file formats.  Supported raster formats are TIFF (tiff, tif), PNG (png), and JPEG (jpg, jpeg).  Supported vector formats are SVG (svg).

l: locations (URI).  The value of this tag is a comma separated list of base URLs representing the location of the brand logo files.   All clients are expected to support use of at least 2 location URIs, used in order.  Clients may optionally attempt to use more.  Initially the supported transport supported is HTTPS only.

v: Version (plain-text; REQUIRED).  Identifies the record retrieved as a BIMI record.  It MUST have the value of "BIMI1".  The value of this tag MUST match precisely; if it does not or it is absent, the entire retrieved record MUST be ignored.  It MUST be the first tag in the list.

z: List of supported image sizes  (comma-separated plain-text list of values; OPTIONAL).  A comma separated list of available image dimensions, written in the form “WxH”, with width W and height H specified in pixels.  Example: a image dimension listed as “512x512” implies a 1x1 aspect ratio image (square) of 512 pixels on a side.  The minimum size of any dimension is 32.  The maximum is 1024.  If the tag is missing or has an empty value, there is no default image dimension.  This lets a Domain Owner broadcast intent that no brand indicator should be used.

Formal Definition {#formal_defintion}
-----------------------

The formal definition of the BIMI format, using [ABNF], is as follows:

location-uri       = URI
                       ; "URI" is imported from [URI]; commas (ASCII
                       ; 0x2C) MUST be encoded

bimi-record    = bimi-version
                       \[bimi-sep bimi-formats\]
                       \[bimi-sep bimi-locations\]
                       \[bimi-sep bimi-image-sizes\]
                       \[bimi-sep\]
                       ; components other than bimi-version
                       ; may appear in any order

bimi-version   = "v" *WSP "=" *WSP %x42 %x49 %x4d %x49 %x31

bimi-sep       = *WSP %x3b *WSP

bimi-size-list = bimi-size*( "," bimi-size) \[ "," \]
bimi-size      = bimi-dimension ("x" / "X") bimi-dimension
bimi-dimension = \[FWS\](2DIGIT / 3DIGIT / 4DIGIT)\[FWS\]


Indicator Discovery {#indicator_discovery}
----------------------------------

As stated above, the BIMI mechanism uses DNS TXT records to advertise preferences.  Preference discovery is accomplished via a method similar to the method used for [DMARC] records.  This method, and the important differences between BIMI and [DMARC] mechanisms, are discussed below.

To balance the conflicting requirements of supporting wildcarding, allowing subdomain policy overrides, and limiting DNS query load, Clients should employ the following lookup scheme for
the appropriate BIMI record for the message:

1. Start with the DNS domain found in the RFC5322.From header in the message.  Define this DNS domain as the Asserted Domain.

2. If the message for which the indicator is being determined specifies a selector value, use this value for the selector (see #bimi-selector).  Otherwise use the value 'default' for the selector

3. Clients MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector, the string '_bimi', and the Asserted Domain.  A possibly empty set of records is returned.

4. Records that do not start with a "v=" tag that identifies the current version of BIMI are discarded.

5. If the set is now empty, the Client MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector 'default', the string '_bimi', and the Organizational Domain (as defined in [DMARC]) corresponding to the Asserted Domain. A custom selector that does not exist falls back to default._bimi.\<organizationalDomain\>, and not \<selector\>._bimi.\<organizationalDomain\>.  A possibly empty set of records is returned.

6. Records that do not start with a "v=" tag that identifies the current version of BIMI are discarded.

7. If the remaining set contains multiple records or no records, indicator discovery terminates and BIMI processing is not performed for this message.

8. If the remaining set contains only a single record, this record is used for indicator discovery.


BIMI verification results in the message headers {#bimi_results}
----------------------------------

Upon completion of BIMI analysis, an MTA SHOULD stamp the result in the Authentication-Results header using the following syntax, with key/value pair key=value

bimi: Result of the bimi lookup (plain-text; REQUIRED). Range of values are 'pass' (BIMI successfully validated), 'none' (no BIMI record present), 'fail' (syntax error in the BIMI record, or some other error), 'temperror' (DNS lookup problem), or 'skipped' (BIMI check did not perform, possibly because the message did not comply with the minimum requirements such as passing DMARC, or the MTA does not trust the sending domain). The MTA MAY put comments in parentheses after bimi result, e.g., bimi=skipped (sender not trusted) or bimi=skipped (message failed DMARC).

header.d: Domain used in a successful BIMI lookup (plain-text; REQUIRED). If the first lookup fails for whatever reason, and the second one passes (e.g., using the organizational domain), the organizational domain should appear here. If both fail (or have no record), then the first domain appears here.

selector: Selector used in a successful BIMI lookup (plain-text; Required). Range of values include the value in the BIMI-Location header, and 'default'. If the first lookup fails (or has no record) and second passes, the second selector should appear here. If both fail (or have no record), then the first selector should appear here.

Example 1 - Successful BIMI lookup

From: sender@example.com
BIMI-Selector: v=BIMI1; s=selector;
Authentication-Results: bimi=pass header.d=example.com selector=selector;

Example 2 - No BIMI record

From: sender@sub.example.com
Authentication-Results: bimi=none header.d=sub.example.com selector=default;

In example 2, sub.example.com does not have a BIMI record at default._bimi.sub.example.com, nor does default._bimi.example.com

Example 3 - Subdomain has no record, but organizataional domain does

From: sender@sub.example.com
Authentication-Results: bimi=pass header.d=example.com selector=default;

Example 4 - Non-default selector specified but DNS record does not exist

From: sender@sub.example.com
BIMI-Selector: v=BIMI1; s=selector;
Authentication-Results: bimi=pass header.d=example.com selector=default;

In example 4, the sender specified a DNS record at selector._bimi.sub.example.com but it did not exist. The fallback is to use default._bimi.example.com (not selector._bimi.example.com) which does exist.

BIMI Location in the message headers {#bimi_location_in_headers}
----------------------------------

Upon successful completion of the BIMI lookup, in addition to stamping the results in the Authentication-Results header, the MTA MUST also stamp the lookup location of the BIMI logo in the RFC5322 BIMI-Location header. The syntax of the header is as following:

BIMI-Location: Header telling the MUA where to get the BIMI logo from. This is formed by combining the 'l' and 'z' values from the BIMI DNS record.

v: BIMI version (plain-text; REQUIRED). Only acceptable value is BIMI1

l: location of the BIMI logo. Inserted by the MTA after parsing through the BIMI DNS record and performing the required checks.

If the BIMI-Location header already exists, it MUST be either stripped off, or renamed.

Example end-to-end flow

1. The domain example.com publishes the following BIMI record:

brand._bimi.example.com IN TXT "v=BIMI1; z=64x64; f=png; l=https://image.example.com/bimi/logo"

2. The sender now sends the message, DKIM signs it, and transmits to the receiver

DKIM-Signature: v=1; s=myExample; d=example.com; h=From;BIMI-Location;Date;bh=...;b=...
From: sender@example.com
BIMI-Selector: v=BIMI1; s=brand;
BIMI-Location: image.example.com/bimi/logo/128x128.gif
Subject: Hi, this is a message from the good folks at Example Learning

3. The receiving MTA receives the message and performs an SPF verification (which fails), a DKIM verification (which passes), and a DMARC verification (which passes). It then proceeds to perform a BIMI lookup.

It sees that the message has a BIMI-Location header, AND it is covered by the DKIM-Signature, and the DKIM-Signature that passed DKIM is the one that covers the BIMI-Location header. The MTA sees the header contains 'v=BIMI1', and 's=brand'. Since there is no 'd=' value in the header, it uses 'd=example.com'. It performs a DNS query for brand._bimi.sub.example.com. It exists, it verifies the syntax of the BIMI DNS record, and it, too passes.

Next, it stamps the results of the BIMI to the Authentication-Results header:

Authentication-Results: spf=pass smtp.mailfrom=example.com;
  dkim=pass (signature was verified) header.d=example.com;
  dmarc=pass action=none header.from=example.com;
  bimi=pass header.d=example.com selector=brand;

Finally, it removes the existing BIMI-Location header, and stamps a new one:

BIMI-Location: v=BIMI1; l=https://image.example.com/bimi/logo/64x64.png

In this example, the BIMI-Location header that the sender included is different from the one that the MTA stamped.


BIMI Record Parsing for the image file {#bimi_record_parsing}
----------------------------------

\[tzink\] This section was originally in the IMAP document, and assumed previously that the MUA would do all of this checking. Moving it to this section instead. But now that I think about it, maybe it *should* be in the MUA/mailstore section since the MTA doesn't know which image the MUA would prefer.\[/tzink\]

A brand or Domain Owner may have multiple BIMI logos for the MUA to select from, and they are permitted to publish all of them in a BIMI DNS record. To pick between them:

1. Look up the DNS record for the l= tag which tells the location of the brand’s logo:

   default._bimi.example.com IN TXT "v=1; f=png; z=512x512; l=https://bimi.example.com/marks

The exact file to download from the location is the z= tag with the f= tag extension, e.g., https://bimi.example.com/marks/512x512.png.

2. The MTA can check the various file at the remote location in any order, but SHOULD give precedence to the order in which they are listed. For example, if the following record were published:

   default._bimi.example.com IN TXT "v=1; f=png,tif,jpg; z=256x256,512x512; l=https://bimi.example.com/marks

This means that there are at least six different files. They will be prioritized by taking the first z= tag and appending all the f= extensions, then taking the next z= tag and appending the f= extensions:

https://bimi.example.com/marks/256x256.png
https://bimi.example.com/marks/256x256.tif
https://bimi.example.com/marks/256x256.jpg
https://bimi.example.com/marks/512x512.png
https://bimi.example.com/marks/512x512.tif
https://bimi.example.com/marks/512x512.jpg

It is NOT done this way (interweaving the sizes):

https://bimi.example.com/marks/256x256.png
https://bimi.example.com/marks/512x512.png
https://bimi.example.com/marks/256x256.tif
https://bimi.example.com/marks/512x512.tif
https://bimi.example.com/marks/256x256.jpg
https://bimi.example.com/marks/512x512.jpg

If a brand owner wants the largest images to show first, they should ensure the 512x512 appears first in the BIMI DNS record. If they want the jpg to take priority, they should publish it first in the DNS record.

This does not guarantee that the first one will be selected as there may be DNS errors, or some clients may not support all formats. However, on average, the first image SHOULD be the one that is used.

Set appropriate flags on the mail store {#mail_store}
----------------------------------

Once an MTA has finished filtering, it needs to deposit the email somewhere where the user can eventually access it with an MUA. Users typically access their email on mail stores through either POP3, IMAP, and MAPI. BIMI currently only supports IMAP (MAPI will have its own implementation).

If a mail store is BIMI-compliant, it sets an IMAP flag on the message when depositing it into the mail store:

$BIMI_display

This tells an accessing MUA that the message passed BIMI.

If a mail store ingests a message from another mail store through some other means, the ingesting mail store may or may not set the $BIMI_display when it pulls down from the other mail store and copies onto itself. If it trusts the other mail store, it may simply set the same flag. Or, it may revalidate BIMI upon ingesting it. Or, it may simply choose not to set the $BIMI_display flag at all.

For more details on the IMAP configuration, see \[insert link\]

Security Considerations   {#security-considerations}
===================

There are several security considarations for BIMI.

1. What's stopping a phisher from creating a lookalike domain, e.g., exxample.com, and publishing BIMI records with a copycat logo, and then those images showing up in the email client?

Answer: Publishing BIMI records is not sufficient for an MTA to signal to the to load the BIMI logo. Instead, the domain-owner should have a good reputation with the MTA. Thus, BIMI display requires passing BIMI, and passing SPF/DKIM/DMARC, and having a good reputation at the receiver. The receiver may use a manually maintained list of large brands, or it may import a list from a third party of good domains, or it may apply its own reputation heuristics before deciding whether or not to load the BIMI logo.

2. Can't the BIMI location have an extremely large logo causing buffer overflows, or cause the client to load a huge image, or something similar?

Answer: The MTA or MUA should perform some basic analysis and avoid loading logos that are too large or too small. The receiver may choose to maintain a manual list and do the inspection of its list offline so it doesn't have to do it at time-of-scan.

3. What about DNS records that take an extremely long time to query?

Answer: All email receivers already have to query for DNS records, and all of them have built-in timeouts when performing DNS queries. Furthermore, the use of caching when loading images can help cut down on load time. Virtually all email clients have some sort of image-downloading built-in and make decisions when to load or not load images.

4. Shouldn't location-uris in an assertion record be required to exist only on the same domain the assertion record is for?

Answer: No. There is no guarantee that a group responsible for managing brand indicators will have access to put these indicators directly in any specific location of a domain, and requiring a match is too high a bar. Additionally, there is no added security from this requirements, as the domain-owner is creating and has control over the location-uri.

5. Shouldn't the BIMI Selector always be DKIM signed?

Answer: It depends. If a Domain Owner relies on SPF but not DKIM for email authentication, then adding a requirement of DKIM may create too high of a bar for that sender. On the other hand, receivers doing BIMI assertion may factor in the lack of DKIM signing when deciding whether to add a BIMI-Location header.

IANA Considerations   {#iana}
===================

IANA will need to reserve two new entrries to the "Permanent Message Header Field Names" registry.

   Header field name: BIMI-Selector

   Applicable protocol: mail

   Status: standard

   Author/Change controller: IETF

   Specification document: This one


    Header field name: BIMI-Location

   Applicable protocol: mail

   Status: standard

   Author/Change controller: IETF

   Specification document: This one

