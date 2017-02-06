---
title: Brand Indicators for Message Identification (BIMI)
docname: draft-brand-indicators-for-message-identification-latest
date: 2017-01-23
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

--- abstract

Brand Indicators for Message Identification (BIMI) is a scalable mechanism by which mail-originating organizations and Mail User Agents (MUAs) can coordinate on displaying brand-specific indicators next to properly authenticated messages.

To benefit their users, Mail User Agents need to be able to effectively and meaningfully convey that messages being displayed are both authenticated and originate from a known organization.  Brand-specific indicators are believed to be a more effective method of communicating message authenticity to end users.  Thus there is a need for MUAs to have access to brand-specific imagery for a very large number of brands.

Those brands have an interest in ensuring that the imagery displayed in these situations is correct and appropriate, so it is desirable to provide a mechanism to allow these mail-originating organizations to provide imagery to MUAs.  This mechanism removes the substantial burden of curating and maintaining an image database from the MUAs, and allows each brand to manage its own imagery.  As an additional benefit, mail-originating organizations are more likely to invest the time and effort to authenticate their email, should that come with the ability to influence how email from the organization is displayed.

By itself BIMI does not impose specific requirements for indicator display on MUAs.  BIMI is just a mechanism to support coordination between mail-originating organizations and MUAs.  MUAs and mail-receiving organizations are free to define their own policies for indicator display that makes use or not of BIMI data as they see fit.


--- middle

Introduction        {#problems}
============

The Sender Policy Framework ([SPF]), DomainKeys Identified Mail ([DKIM]), and Domain-based Message Authentication, Reporting, and Conformance ([DMARC]) provide mechanisms for domain-level authentication for email messages.  They enable cooperating email senders and receivers to distinguish messages that are authorized to use the domain name from those that are not.  Given that not all senders employ these authentication mechanisms, it is desirable that Mail User Agents be able to indicate to their end users that particular messages are authenticated.

It is currently possible for Mail User Agents to indicate the validity of messages authenticated via these mechanisms through the use of generic indicators - checkmarks and the like.  But there is a belief that the effectiveness of such generic indicators is limited, and that end users are better served through the use of brand indicators associated with the authenticated sender of the message.

The Need for Standardization   {#need}
----------------------------

Over time, some mail-receiving organizations have developed closed systems for displaying brand indicators for some select domains.  While this enabled these mail-receiving organizations to display brand indicators for a limited subset of messages, this closed approach has significant downsides.  Namely:

1. It puts a significant burden on each mail-receiving organization, because they must identify and manage a large database of brand indicators.
2. Scalability is challenging for closed systems that attempt to capture complete sets of data across the whole of the Internet.
3. A lack of uniformity across different mail-receiving organizations - each organization will have its own indicator set, which may or may not agree with those maintained by other organizations for any given domain.
4. Domain owners have limited ability to influence the brand indicator for the domain(s) they own, and such ability they do have is likely to require coordination with many mail-receiving organizations.
5. MUAs that are not associated with a particular mail-receiving organization are likely to be disadvantaged, because they are unlikely

This all speaks to the need for a standardized mechanism by which Domain Owners can publish and distribute brand indicators for use by any participating MUA.

Outline   {#outline}
----------------------------

This document defines Brand Indicators for Message Identification (BIMI), a mechanism by which Domain Owners can coordinate with mail-receiving organizations and Mail User Agents to express preferred brand indicators for display with a given message.

The basic outline of BIMI is as follows:

1.  Domain Owners publish brand indicator assertions for domains via the DNS.
2.  Receivers authenticate the messages using [DMARC] and/or whatever other authentication mechanisms they wish to apply.
3.  If the message authenticates, the receiver queries the DNS for a corresponding BIMI record.
4.  If a BIMI record is present, then the receiver adds a header to the message, which can be used by the Mail User Agent to determine the Domain Owner's preferred brand indicator.
5.  The Mail User Agent retrieves and displays the brand indicator as appropriate based on its policy and user interface.

Requirements   {#requirements}
========================

Specification of BIMI in this document is guided by the following high-level goals, security dependencies, detailed requirements, and items that are documented as out of scope.

High-Level Goals    {#goals}
-----------------

BIMI has the following high-level goals:

* Enable the authors of Mail User Agents to display meaningful imagery associated with the author to recipients of authenticated email.
* Allow Domain Owners to suggest appropriate images for display with authenticated messages originating from their domains.
* Provide mechanisms to prevent attempts by malicious Domain Owners to fraudulently represent messages from their domains as originating with other entities.
* Work at Internet Scale

Out of Scope {#out-of-scope}
-------------

Several topics and issues are specifically out of scope for the initial version of this work.  These include the following:

* Defining what consitutes authenticated email for the purposes of this standard
* Publishing policy other than via the DNS
* The explicit mechanisms used by Verifying Protocol Clients - this will be deferred to a later document.

Scalability {#scalability}
------------

Scalability is a major issue for systems that need to operate in a system as widely deployed as current SMTP email.  For this reason, BIMI seeks to avoid the need for pre-sending agreements between senders and receivers.  This preserves the positive aspects of the current email infrastructure.

Terminology and Definitions   {#terminology}
========================

This section defines terms used in the rest of the document.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{KEYWORDS}}.

Readers are encouraged to be familiar with the contents of [EMAIL-ARCH].  In particular, that document defines various roles in the messaging infrastructure that can appear the same or separate in various contexts.  For example, a Domain Owner could, via the messaging mechanisms on which BIMI is based, delegate control over defining preferred brand indicators as the Domain Owner to a third party with another role.  This document does not address the distinctions among such roles; the reader is encouraged to become familiar with that material before continuing.

The following terms are also used:

   Author Domain:  The domain name of the apparent author, as extracted from the RFC5322.From field.

   Domain Owner:  An entity or organization that owns a DNS domain.  The term "owns" here indicates that the entity or organization being referenced holds the registration of that DNS domain.  Domain Owners range from complex, globally distributed organizations, to service providers working on behalf of non-technical clients, to individuals responsible for maintaining personal domains.  This specification uses this term as analogous to an Administrative Management Domain as defined in [EMAIL-ARCH].

   Mail Receiver:  The entity or organization that receives and processes email.  Mail Receivers operate one or more Internet-facing Mail Transport Agents (MTAs).

   Mark Asserting Entity (MAE): A Domain Owner who publishes information via the protocol to facilitate distribution of its graphical icons or marks in association with messages for which the domain they "own" is the Author Domain.

   Mark Verifying Authority (MVA): An entity of organization that can provide evidence of verification of marks asserted by an MAE to Verifying Protocol Clients.  The MVA may choose to uphold and confirm the meeting of certain mark standards (ie. size, trademark, content, etc).

   Protocol Client: An entity that uses the protocol to discover and fetch published icons or marks.

   Verifying Protocol Client: A Protocol Client that uses the optional verification capability to inquire about the verification status of published marks.

Overview   {#overview}
========================

This section provides a general overview of the design and operation of the BIMI environment.

Selectors   {#selectors}
------------------------

To support multiple brand indicators per domain, the brand indicator namespace is subdivided using "selectors".  Selectors allow the domain owner to better target the brand indicator by type of recipient, message source, or other considerations like seasonal branding.

Periods are allowed in selectors and are component separators.  When BIMI assertion records are retrieved from the DNS, periods in selectors define DNS label boundaries in a manner similar to the conventional use in domain names.  In a DNS implementation, this can be used to allow delegation of a portion of the selector namespace.

[ABNF]:

selector =   sub-domain *( "." sub-domain )
             ; from [SMTP] Domain,
             ; excluding address-literal

The number of selectors for each domain is determined by the domain owner.  Many domain owners will be satisfied with just one selector, whereas organizations with more complex branding requirements can choose to manage disparate selectors.

BIMI supports the notion of a "default" selector.

Use of RFC5322.From   {#rfc5322_from}
-------------------------------------

Policy {#policy}
===================

BIMI policies are published by Domain Owners and applied by Protocol Clients.

A Domain Owner advertises BIMI participation of one or more of its domains by adding a DNS TXT record to those domains.  In doing so, Domain Owners make specific requests of Mail User Agents regarding the preferred set of icons to be displayed with messages purporting to be from one of the Domain Owner's domains.

A Domain Owner may choose not to participate in BIMI.  In this case, the Domain Owner simply declines to advertise participation by not publishing a BIMI assertion record.

A Mail User Agent implementing the BIMI mechanism SHOULD make a best-effort attempt to adhere to the Domain Owner's published BIMI policy.  But Mail User Agents have final control over the user interface published to their end users, and MAY use alternate indicators than those specified in the BIMI assertion record or no indicator at all.

Assertion Record {#assertion-record}
-----------------

All Domain Owner BIMI preferences are stored as DNS TXT records in subdomains named "_bimi".  BIMI allows the definition of multiple preferences associated with a single RFC5322.From domain.  To distinguish between these different preferences, BIMI uses selectors.

For example, the Domain Owner of "example.com" would post BIMI preferences in a TXT record at "default._bimi.example.com".  Similarly, a Mail Receiver wishing to query for BIMI preferences regarding mail with an RFC5322.From domain of "example.com" and a selector "default" would issue a TXT query to the DNS for the subdomain of "default._bimi.example.com".  The DNS-located BIMI preference data will hereafter be called the "BIMI assertion record".

BIMI's use of the Domain Name Service is driven by BIMI's use of domain names and the nature of the query it performs. Use of the DNS as the query service has the benefit of reusing an extremely well-established operations, administration, and management infrastructure, rather than creating a new one.

Per [DNS], a TXT record can comprise several "character-string" objects.  Where this is the case, the module performing DMARC evaluation MUST concatenate these strings by joining together the objects in order and parsing the result as a single string.

General Record Format {#general-record-format}
----------------------

BIMI assertion records follow the extensible "tag-value" syntax for DNS-based key records defined in DKIM [DKIM].

This section creates a registry for known BIMI tags and registers the initial set defined in this document.  Only tags defined in this document or in later extensions, and thus added to that registry, are to be processed; unknown tags MUST be ignored.

The following tags are introduced as the initial valid BIMI tags:

a: Trust Authorities (plain-text; OPTIONAL).  A reserved value.

f: Supported Image Formats (comma-separated plain-text list of values; OPTIONAL; default is "png").  Comma-separated list of three or four character filename extensions denoting the available file formats.  Supported raster formats are TIFF (tiff, tif), PNG (png), and JPEG (jpg, jpeg).  Supported vector formats are SVG (svg).

l: locations (URI).  The value of this tag is a comma separated list of base URLs representing the location of the brand logo files.   All clients are expected to support use of at least 2 location URIs, used in order.  Clients may optionally attempt to use more.  Initially the supported transport supported is HTTPS only.

v: Version (plain-text; REQUIRED).  Identifies the record retrieved as a BIMI record.  It MUST have the value of "BIMI1".  The value of this tag MUST match precisely; if it does not or it is absent, the entire retrieved record MUST be ignored.  It MUST be the first tag in the list.

z: List of supported image sizes  (comma-separated plain-text list of values; OPTIONAL).  A comma separated list of available image dimensions, written in the form “WxH”, with width W and height H specified in pixels.  Example: a image dimension listed as “512x512” implies a 1x1 aspect ratio image (square) of 512 pixels on a side.  The minimum size of any dimension is 32.  The maximum is 1024.  If the tag is missing or has an empty value, there is no default image dimension.  This lets a domain owner broadcast intent that no brand indicator should be used.

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

2. If the message for which the indicator is being determined specifies a selector value, use this value for the selector.  Otherwise use the value 'default' for the selector

3. Clients MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector, the string '_bimi', and the Asserted Domain.  A possibly empty set of records is returned.

4. Records that do not start with a "v=" tag that identifies the current version of BIMI are discarded.

5. If the set is now empty, the Client MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector, the string '_bimi', and the Organizational Domain (as defined in [DMARC]) corresponding to the Asserted Domain.  A possibly empty set of records is returned.

6. Records that do not start with a "v=" tag that identifies the current version of BIMI are discarded.

7. If the remaining set contains multiple records or no records, indicator discovery terminates and BIMI processing is not performed for this message.

8. If the remaining set contains only a single record, this record is used for indicator discovery.



Security Considerations   {#security}
===================


