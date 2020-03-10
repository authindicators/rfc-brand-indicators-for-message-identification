---
title: Brand Indicators for Message Identification (BIMI)
docname: draft-blank-ietf-bimi-01
date: 2020-02-20
category: exp

workgroup: Network Working Group
keyword: Internet-Draft

normative:
  ABNF:
    target: http://www.rfc-editor.org/info/rfc5234
    title: "Augmented BNF for Syntax Specifications: ABNF"
    author:
      ins: Crocker, D., Ed., and P. Overell
    date: January 2008
  ARC:
    target: http://www.rfc-editor.org/info/rfc8617
    title: The Authenticated Received Chain (ARC) Protocol
    author:
      ins: K. Andersen, B. Long, Ed., S. Blank, Ed., and M. Kucherawy, Ed.
    date: July 2019
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
    ins: S. Blank
    name: Seth Blank
    organization: Valimail
    email: seth@valimail.com
 -
    ins: P. Goldstein
    name: Peter Goldstein
    organization: Valimail
    email: peter@valimail.com
 -
    ins: T. Loder
    name: Thede Loder
    organization: Skye Logicworks LLC
    role: editor
    email: thede@skyelogicworks.com
 -
    ins: T. Zink
    name: Terry Zink
    role: editor
    email: tzink@terryzink.com
 -
    ins: M. Bradshaw
    name: Marc Bradshaw
    organization: Fastmail
    role: editor
    email: marc@fastmailteam.com

--- abstract

Brand Indicators for Message Identification (BIMI) permits Domain Owners to coordinate with Mail User Agents (MUAs) to display brand-specific Indicators next to properly authenticated messages.  There are two aspects of BIMI coordination: a scalable mechanism for Domain Owners to publish their desired indicators, and a mechanism for Mail Transfer Agents (MTAs) to verify the authenticity of the indicator.  This document specifies how Domain Owners communicate their desired indicators through the BIMI Assertion Record in DNS and how that record is to be interpreted by MTAs and MUAs.  The domain verification mechanism and extensions for other mail protocols (IMAP, etc.) are specified in separate documents. MUAs and mail-receiving organizations are free to define their own policies for making use of BIMI data and for indicator display as they see fit.

--- middle

Introduction        {#problems}
============

This document defines Brand Indicators for Message Identification (BIMI), which permits Domain Owners to coordinate with Mail User Agents (MUAs) to display brand-specific Indicators next to properly authenticated messages.

BIMI is designed to be open and to work at Internet scale.  For some senders of email, the display of Indicators BIMI is intended to enable and coordinate will be an incentive to adopt the required email authentication practices.  

The approach taken by BIMI is heavily influenced by the approach taken in [DKIM](https://tools.ietf.org/html/rfc6376#section-1), in that BIMI:

* has no dependency on the deployment of any new Internet protocols or services for indicator registration or revocation;
* makes no attempt to include encryption as part of the mechanism;
* is compatible with the existing email infrastructure and transparent to the fullest extent possible;
* requires minimal new infrastructure;
* can be implemented independently of clients in order to reduce deployment time;
* can be deployed incrementally; and
* allows delegation of indicator hosting to third parties.

This document defines the BIMI mechanism for Domain Owners to publish their desired indicators and describes how Mail Transfer Agents (MTAs) and MUAs should handle this communication.  This document does not cover how domains or indicators are verified, how MUAs should display the indicators, or how other protocols (i.e. IMAP, JMAP) can be extended to work with BIMI.  Other documents may cover these topics.

Overview        {#why-bimi}
============

The Sender Policy Framework ([SPF]), DomainKeys Identified Mail ([DKIM]), and Domain-based Message Authentication, Reporting, and Conformance ([DMARC]) provide mechanisms for domain-level authentication of email messages.  They enable cooperating email senders and receivers to distinguish messages that are authorized to use the domain name from those that are not. BIMI relies on these authentication protocols, but is not a new authentication protocol itself.

MUAs are increasingly incorporating graphical logos to indicate the identity of the sender of a message.  While a discussion of the merits of doing this are beyond the scope of this document, at present there are no open standards for publishing and aiding discovery of preferred logos or for tying display of them to authentic messages only. 

Because of the desire to have brand-specific indicators available, some mail-receiving organizations have developed closed systems for obtaining and displaying brand indicators for select domains.  While this has enabled these mail-receiving organizations to display brand indicators for a limited subset of messages, this closed approach has significant downsides:

1. It puts a significant burden on each mail-receiving organization, because they must identify and manage a large database of brand indicators.
2. Scalability is challenging for closed systems that attempt to capture and maintain complete sets of data across the whole of the Internet.
3. A lack of uniformity across different mail-receiving organizations - each organization will have its own indicator set, which may or may not agree with those maintained by other organizations for any given domain.
4. Domain Owners have limited ability to influence the brand indicator for the domain(s) they own, and any ability they do have is likely to be dependent upon direct coordination with each of many mail-receiving organizations.
5. Many Domain Owners have no ability to participate whatsoever as they do not have the appropriate relationships to coordinate with mail-receiving organizations.
6. MUAs that are not associated with a particular mail-receiving organization are likely to be disadvantaged, because they are unlikely to receive indicators in a standardized manner or optimized for their user interfaces.  

This all speaks to the need for a standardized mechanism by which Domain Owners interested in ensuring that their indicators are displayed correctly and appropriately can publish and distribute brand indicators for use by any participating MUA.

BIMI removes from the MUAs the substantial burden of curating and maintaining an indicator database, and allows each domain to manage its own indicators available for use.  As an additional benefit, mail-originating organizations are more likely to invest the time and effort to authenticate their email should doing so come with the ability to influence how email and Indicators from the organization are displayed.

The basic structure of BIMI is as follows:

1. Domain Owners publish their preferred brand indicators for their domains via the [DNS].

2. Then, for any message received by a Mail Receiver:

    a. The receiver confirms authenticity of the message using [DMARC] and whatever other authentication mechanisms they wish to apply.

    b. The receiver checks for a corresponding BIMI record, obtaining references to the indicator media and optional substantiation of indicator ownership rights

    c. If both the message is authentic and the logo is deemed acceptable, the receiver adds a header to the message which can be used by the MUA to obtain the Domain Owner's preferred brand indicator.

3. The MUA retrieves and displays the brand indicator as appropriate based on its policy and user interface.

The purpose of this structure is to reduce operational complexity at each step.  It is also to consolidate validation and indicator selection operations into the MTA, so that Domain Owners need only publish a few simple records and MUAs only need simple display logic.

Requirements   {#requirements}
========================

Specification of BIMI in this document is guided by the following high-level goals, security dependencies, detailed requirements, and items that are documented as out of scope.

High-Level Goals    {#goals}
-----------------

BIMI has the following high-level goals:

* Allow Domain Owners to suggest appropriate indicators for display with authenticated messages originating from their domains.
* Enable the authors of MUAs to display meaningful indicators associated with the Domain Owner to recipients of authenticated email.
* Provide mechanisms to prevent attempts by malicious Domain Owners to fraudulently represent messages from their domains as originating with other entities.
* Work at Internet Scale.

Security     {#security}
------------

Brand indicators are a potential vector for abuse.  BIMI creates a relationship between sending organization and Mail Receiver so that the receiver can display appropriately designated indicators if the sending domain is verified and has meaningful reputation with the receiver.  Without verification and reputation, there is no way to prevent a bad actor exxample.com from using example.com's brand indicators and behaving maliciously.  This document does not cover these verification and reputation mechanisms, but BIMI requires them to control abuse.

Out of Scope     {#out-of-scope}
-------------

Several topics and issues are specifically out of scope for the initial version of this work.  These include the following:

* Publishing policy other than via the DNS.
* Specific requirements for indicator display on MUAs.
* The explicit mechanisms used by Verifying Protocol Clients - this will be deferred to a later document.

Terminology and Definitions   {#terminology}
========================

This section defines terms used in the rest of the document.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{KEYWORDS}}.

Readers are encouraged to be familiar with the contents of [EMAIL-ARCH].  In particular, that document defines various roles in the messaging infrastructure that can appear the same or separate in various contexts.  For example, a Domain Owner could, via the messaging mechanisms on which BIMI is based, delegate reponsibility for providing preferred brand indicators to a third party with another role.  This document does not address the distinctions among such roles; the reader is encouraged to become familiar with that material before continuing.

Syntax descriptions use Augmented BNF [ABNF].

"Author Domain", "Domain Owner", "Organizational Domain", and "Mail Receiver" are imported from [DMARC] Section 3.

BIMI Assertion
-------------

The mechanism through which a Protocol Client verifies the BIMI Assertion Record and constructs the URI(s) to the requested indicator(s) to be placed in the BIMI-Location header.

Indicator
-------------

The icon, image, mark, or other graphical representation of the brand. The Indicator is defined in a common image format with restrictions detailed in the [Assertion Record definition](#assertion-record-def).

Mark Verifying Authority (MVA)
-------------

An entity of organization that can provide evidence of verification of indicators asserted by a Domain Owner to Verifying Protocol Clients.  The MVA may choose to uphold and confirm the meeting of certain indicator standards (ie. size, trademark, content, etc).

Verified Mark Certificate (VMC)
-------------

A certificate issued by a Certificate Authority in accordance with the Verified Mark Certificate Guidelines.  These guidelines are defined in a separate document.


Protocol Client
-------------

An entity designed to obtain and correctly interpret the records defined in this specification for the purpose of discovering and fetching published indicators.

Verifying Protocol Client
-------------

A Protocol Client that uses optional capabilities to obtain and evaluate evidence concerning the Domain Owner's rights to use the published Indicators. 

BIMI DNS Records   {#bimi-dns}
=============

Domain owners publish their BIMI policies through BIMI Assertion Records.  Each Assertion Record is DNS TXT record, with a format and the meaning of its text-based contents specific to BIMI and specified herein.  

Published policies are interpreted and applied by Protocol Clients.  A Domain Owner signals intended BIMI participation for one or more of its domains by publishing an Assertion Record in a subdomain under it.  In doing so, Domain Owners make specific requests of MUAs regarding the preferred set of indicators to be displayed with messages that are confirmed to be authorized to appear from the Domain Owner's domain.

The use of BIMI is opt-in.  Receivers default to performing no BIMI-specific message handling unless a BIMI record for the sender's domain is found.  By merely doing nothing, BIMI use is avoided. 

BIMI's use of the DNS is driven in part by BIMI's use of domain names as the basis of sender identity and message authentication. Use of the DNS as the policy publication service also has the benefit of reusing an extremely well-established operations, administration, and management infrastructure, rather than creating a new one.

BIMI's policy payload is intentionally only published via a DNS record and not via one or more email headers. This serves four purposes:

1. There is one and only one mechanism for both simple and complex policies to be published.

2. Operational complexity is reduced.  MTAs only need to check a single record in a consistent manner to discover and enforce policy.

3. MTAs that understand their MUAs have more control over which Indicators they choose for those MUAs.

4. Indicators can be verified and/or cached in advance, so that malicious headers cannot be used as an attack vector.

Per [DNS], a TXT record can comprise several "character-string" objects. BIMI TXT records with multiple strings must be treated in an identical manner to [SPF Section 3.3](https://tools.ietf.org/html/rfc7208#section-3.3).

MUA Obligations {#mua_guidance}
-----------------

MUAs implementing the BIMI mechanism SHOULD make a best-effort attempt to adhere to the Domain Owner's published BIMI policy.  However, MUAs have final control over the user interface published to their end users, and MAY use alternate indicators than those specified in the BIMI assertion record or no indicator at all.


Assertion Record   {#assertion-record-def}
-----------------

All Domain Owner BIMI preferences are expressed in DNS TXT records published in subdomains named "_bimi".  Multiple sets of preferences can be associated with a single RFC5322.From domain.  To distinguish between these different preferences, BIMI defines and uses [selectors](#selectors). Senders declare which selector to use for a given message by specifying the selector in an optional [BIMI-Selector header](#bimi-selector).

For example, the Domain Owner of "example.com" would post BIMI policy in a TXT record at "default._bimi.example.com".  Similarly, a Mail Receiver wishing to query for BIMI policy regarding mail with an RFC5322.From Author Domain of "example.com" and a selector "default" (the default) would query the TXT record located at the subdomain of "default._bimi.example.com".  The DNS-based BIMI policy record is referred to as the "BIMI Assertion Record" or "Assertion Record".

BIMI Assertion Records follow the extensible "tag-value" syntax for DNS-based key records as defined in [DKIM].

Assertion Records are defined precisely. Mail receivers MUST NOT attempt to fix syntactical or capitalization errors. If a required tag is missing, or its value not well-formed, it is an error.

This section creates a registry for known BIMI tags and registers the initial set defined in this document.  Only tags defined in this document or in later extensions, and thus added to the registry, are to be processed; unknown tags MUST be ignored.

The following tags are introduced as the initial valid BIMI tags:

v= Version (plain-text; REQUIRED).  Identifies the record retrieved as a BIMI record.  It MUST have the value of "BIMI1" for implementations compliant with this version of BIMI.  The value of this tag MUST match precisely; if it does not match or it is absent, the entire retrieved record MUST be ignored.  It MUST be the first tag in the list.

    ABNF:

    bimi-version = %x76 *WSP "=" *WSP %x42.49.4d.49 1DIGIT

a= Authority Evidence Locations (plain-text; URI; OPTIONAL).  If present, this tag MUST have an empty value or its value MUST consist of a list of between one and three comma-separated URIs.  An empty value for the tag is interpreted to mean the Domain Owner does not wish to publish or does not have authority evidence to disclose.  Each URI, if present in the optional list, MUST contain a fully qualfied domain name (FQDN) and MUST specify HTTPS as the URI scheme ("https").  Further, each URI SHOULD specify the location of a publicly retrivable evidence document.  Clients with the capability of retriving evidence documents SHOULD support use of at least two URIs from the list, used in order.  Clients MUST skip consideration of an evidence document if the TLS server identity certificate presented during the TLS session setup does not chain-up to a root certificate the Client trusts.  Evidence documents located at each URI MUST be PEM-encoded X.509v3 certificate chains and start with an end entity certificate that is a Verified Mark Certificate (VMC).  The Verified Mark Certificate MUST be compliant with the Verified Mark Certificate Profile.  Intermediate certificates and any issuer certificates needed to reach the root of the VMC issuer SHOULD be provided in the evidence document.  If the a= tag is not present, it is assumed to have an empty value.  

    ABNF:

    bimi-evidence-locations = %x61 *WSP "=" bimi-evidence-location-uri *("," bimi-evidence-location-uri) \[","\]

    bimi-evidence-location-uri = \[FWS\] URI \[FWS\]

    ; "URI" is imported from [URI]
    ; HTTPS only
    ; commas within a URI (ASCII ; 0x2C) MUST be encoded

    NOTE TO WORKING GROUP: The a= tag value is a short list of VMC certificate locations.  Should we wish to introduce additional approaches for Domain Owners to publish evidence of rights, we can introduce additional tags. 

    ABNF:

    bimi-location-uri = \[FWS\] URI \[FWS\]

    ; "URI" is imported from [URI]
    ; HTTPS only
    ; commas (ASCII ; 0x2C) MUST be encoded

    bimi-locations = %x6c *WSP "=" bimi-location-uri *("," bimi-location-uri) \[","\]

Therefore, the formal definition of the BIMI Assertion Record, using [ABNF], is as follows:

    bimi-sep = *WSP %x3b *WSP

    bimi-record = bimi-version (bimi-sep bimi-locations) (bimi-sep bimi-authorities) \[bimi-sep\]
 
    ; components other than bimi-version may appear in any order

### Declination to Publish

If both the "l=" and "a=" tags are empty, it is an explicit refusal to participate in BIMI. This is distinct from not publishing a BIMI record.  For example, an empty BIMI record enables a Domain Owner to decline BIMI participation for a subdomain when its organizational domain has default Indicators available. Furthermore, messages sent using a selector that has declined to publish will not show an Indicator while messages with other selectors would display normally.

An explicit declination to publish looks like:

    v=BIMI1; l=; a=;

### Supported Image Formats for l= tag

Any format in the BIMI-formats IANA registry are acceptable targets for the l= tag. If an l= tag URI ends with any other image format suffix, or if the document retrievable from the location(s) in the l= tag are of any other format, the evaluation of the record MUST be treated as a permanent error.

As of the publishing of this document, only SVG, as defined in (RFC6170 section 5.2)[https://tools.ietf.org/html/rfc6170#section-5.2] is acceptable in the l= tag.  Further restrictions may apply to the SVG, and if so, these are documented elsewhere. 

Selectors   {#selectors}
------------------------

To support publishing and display of more than one distinct brand indicator per domain, the brand indicator namespace is subdivided for publishing of multiple Assertion Records using "selectors".  Selectors allow the Domain Owner to choose the brand indicator, for example, by type of recipient, by message source, or by other considerations like seasonal branding.  BIMI selectors are modeled after [DKIM selectors](https://tools.ietf.org/html/rfc6376#section-3.1).

The selector "default" is the default Assertion Record. Domain Owners can specify which other selector to use on a per-message basis by utilizing the [BIMI-Selector Header](#bimi-selector).

Periods are allowed in selectors and are component separators.  When BIMI Assertion Records are retrieved from the DNS, periods in selectors define DNS label boundaries in a manner similar to the conventional use in domain names.  In a DNS implementation, this can be used to allow delegation of a portion of the selector namespace.

    ABNF:

    selector = sub-domain *( "." sub-domain )

    ; from [SMTP] Domain,

    ; excluding address-literal

The number of selectors for each domain is determined by the Domain Owner.  Many Domain Owners will be satisfied with just one selector, whereas organizations with more complex branding requirements can choose to manage disparate selectors.  BIMI sets no maximum limit on the number of selectors.

BIMI Header Fields   {#bimi-headers}
=============

Once BIMI policies are published in DNS via Assertion Records, Domain Owners can provide additional guidance to Mail Receivers, and Mail Receivers to their MUAs through the use of BIMI header fields.

BIMI header fields are case insensitive. If a required tag is missing, it is an error.

BIMI-Selector Header {#bimi-selector}
----------------------

BIMI DNS records are placed in \<selector\>._bimi.\<domain\>, and by default they are placed in default._bimi.\<domain\>. That is, for example.com, the default Assertion Record is located in the DNS at default._bimi.example.com. However, a Domain Owner may override the use of the default selector and specify the use of an alternative using the RFC5322-compliant header 'BIMI-Selector'. The BIMI-Selector header consists of key value pairs:

v= Version (plain-text; REQUIRED). The version of BIMI. It MUST have the value of "BIMI1" for implementations compliant with this version of BIMI.  The value of this tag MUST match precisely; if it does not or it is absent, the entire retrieved record MUST be ignored.  It MUST be the first tag in the list.

    ABNF:

    bimi-header-version = "v" *WSP "=" *WSP "BIMI" 1DIGIT

s= Selector (plain-text; REQUIRED). The location of the BIMI DNS record, when combined with the RFC5322.From domain.

    ABNF:

    bimi-selector = "s" *WSP "=" *WSP selector

And the formal definition of the BIMI Selector Header, using ABNF, is as follows:

    bimi-selector-header = bimi-header-version bimi-sep bimi-selector \[bimi-sep\]

BIMI-Location Header {#bimi-location}
----------------------------------

BIMI-Location is the header a Mail Receiver inserts that tells the MUA where to get the BIMI indicator from.

The syntax of the header is as following:

v= Version (plain-text; REQUIRED). The version of BIMI. It MUST have the value of "BIMI1" for implementations compliant with this version of BIMI.  The value of this tag MUST match precisely; if it does not or it is absent, the entire header MUST be ignored.  It MUST be the first tag in the list.

    The ABNF for bimi-header-version is imported exactly from the [BIMI Selector Header](#bimi-selector).

l: location of the BIMI indicator (URI; REQUIRED). Inserted by the MTA after performing the required checks and obtaining the applicable domain's published Assertion Record.  The value of this tag is a comma-separated list of URLs representing locations of the brand indicator files. All clients MUST support use of at least 2 location URIs, used in order.  Clients MAY support more locations.  Initially the supported transport supported is HTTPS only.  

    ABNF:

    bimi-header-locations = "l" *WSP "=" bimi-location-uri *("," bimi-location-uri) \[","\]

And the formal definition of the BIMI Location Header, using ABNF, is as follows:

    bimi-location-header = bimi-header-version bimi-sep bimi-header-locations \[bimi-sep\]


Header Signing
---------------

The BIMI-Selector SHOULD be signed by DKIM.
=======

If present, the BIMI-Selector header SHOULD be included in the DMARC-aligned DKIM signature used to confirm authenticity of the message.  If it is not included in the DMARC-compliant DKIM signature, the header should be ignored.  

Receivers MAY choose to apply additional methods to validate the BIMI-Selector header, for example by evaluating a trusted [ARC] chain. In this case the Receiver MAY choose to treat the message as if the BIMI-Selector header was signed.  

The BIMI-Location header MUST NOT be DKIM signed. This header is untrusted by definition, and is only for use between an MTA and its MUAs, after DKIM has been validated by the MTA. Therefore, signing this header is meaningless, and any messages with it signed are either coming from malicious or misconfigured third parties.

Domain Owner Actions    {#bimi-sender}
=============

This section includes a walk through of the actions a Domain Owner takes when setting up Assertion Records and sending email messages.

Determine and Publish Indicator(s) for Use
-------------

Domain Owners should consider which Indicator file formats to choose when setting up their BIMI Assertion Records. For a Sender, BIMI provides control over which Indicators are eligible and can be chosen for display, but not the ultimate manner in which the MUA will display the image.

BIMI allows multiple comma separated l= values in the Assertion Record, so that a Domain Owner may publish the same Indicators in multiple publicly accessible locations. This is so Indicators may still be available if there are service or DNS issues for a particular "l=" URI.  

Specify Domain Owner Preference
-------------

The ordering of the l= tag is significant, the first location specified should have priority over the second, etc.

This does not guarantee that the first tags specified will be selected as there may be DNS errors, or some clients may not support all valid formats. However, on average, the first tags specified SHOULD be used to construct the indicator passed to the MUA.

Publish Assertion Records
-------------

For each set of Indicators and domains, publish the appropriate Assertion Record as either "default" or a named selector as a DNS TXT record within the appropriate "_bimi" namespace.

Manage multiple uses of the same Indicator(s) within a trust boundary
-------------

For Domain Owners with multiple domains that wish to share the same set of Indicators within a trust boundary and only manage those Indicators from a single DNS location, it is RECOMMENDED to use DNS CNAMEs.

Using a CNAME here is functionally similar to the SPF redirect modifier. Since BIMI does not require l= tags to be aligned to the Author Domain, CNAMEs present a cleaner solution than extending the protocol. 
 
Set the headers on outgoing email as appropriate
-------------

Once a default Assertion Record has been published for an Author Domain, all emails from this domain should display the appropriate Indicator in participating MUAs.

If a non-default Indicator is desired, the BIMI-Selector header should be set appropriately. If for some reason this selector cannot be accessed by the Protocol Client, the fallback is the default Assertion Record on the Organization domain.

The BIMI-Location header MUST NOT be set by email senders, and Protocol Clients MUST ignore it.

Receiver Actions   {#bimi-receiver}
=============

This section includes a walk through of the actions a Protocol Client takes when evaluating an email message for BIMI Assertion.

Authentication Requirements {#authentication-requirements}
----------------------------------------------------------

Before applying BIMI processing for a message, a receiver MUST verify that the message passed the following BIMI authentication requirements:

1. If more than 1 RFC5322.From header is present in the message, or any RFC5322.From header contains more than 1 email address then BIMI processing MUST NOT be performed for this message.

2. Start with the DNS domain found in the RFC5322.From header in the message.  Define this DNS domain as the Author Domain.

3. Evaluate the [DMARC] result for the Author Domain.  Define the result as the BIMI DMARC Result.

4. If the BIMI DMARC result is not 'pass', then the receiver MAY choose to apply additional authentication methods, for example by evaluating a trusted [ARC] chain or a list of trusted forwarders. In this case the Receiver MAY choose to treat the message as if the BIMI DMARC Result was 'pass'.

5. If the [DMARC] result for the Author Domain is not 'pass', and the message could not be authenticated by any additional authentication method, then BIMI processing MUST NOT be performed for this message.

6. If the [DMARC] policy for the Author Domain is p=none then BIMI processing MUST NOT be performed for this message.

7. IF the [DMARC] record for the Author Domain includes a subdomain policy, and that subdomain policy is sp=none then BIMI processing MUST NOT be performed for this message.

8. If the [DMARC] policy for the Author Domain is p=quarantine, and the [DMARC] record defines a percentage tag, then that tag MUST be pct=100, otherwise BIMI processing MUST NOT be performed for this message.

9. If the Author Domain has an [SPF] policy, and that policy ends with +all, then BIMI processing MUST NOT be performed for this message.

Indicator Discovery {#indicator-discovery}
----------------------------------

Through the [BIMI Assertion Record](#assertion-record-def), Domain Owners use DNS TXT records to advertise their preferences.  Preference discovery is accomplished via a method similar to the method used for [DMARC] records.  This method, and the important differences between BIMI and [DMARC] mechanisms, are discussed below.

Indicator Discovery MUST only be attempted if the message authenticates per Receiver policy.

To balance the conflicting requirements of supporting wildcarding, allowing subdomain policy overrides, and limiting DNS query load, Protocol Clients MUST employ the following lookup scheme for the appropriate BIMI record for the message:

1. Start with the DNS domain found in the RFC5322.From header in the message.  Define this DNS domain as the Author Domain.

2. If the message for which the indicator is being determined specifies a selector value in the [BIMI Selector Header](#bimi-selector), use this value for the selector.  Otherwise the value 'default' MUST be used for the selector.

3. Clients MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector, the string '_bimi', and the Author Domain.  A possibly empty set of records is returned.

4. Records that do not start with a "v=" tag that identifies the current version of BIMI MUST be discarded.

5. If the set is now empty, the Client MUST query the DNS for a BIMI TXT record at the DNS domain constructed by concatenating the selector 'default', the string '_bimi', and the Organizational Domain (as defined in [DMARC]) corresponding to the Author Domain. A custom selector that does not exist falls back to default._bimi.\<organizationalDomain\>, and NOT \<selector\>._bimi.\<organizationalDomain\>.  A possibly empty set of records is returned.

6. Records that do not start with a "v=" tag that identifies the current version of BIMI MUST be discarded.

7. If the remaining set contains multiple records or no records, indicator discovery terminates and BIMI processing MUST NOT be performed for this message.

8. If the remaining set contains only a single record, this record is used for BIMI Assertion.

Indicator Validation {#indicator-validation}
----------------------------------

If an Assertion Record is found and has an a= tag, it must be used to validate the indicator using the following algorithm:

1. Use the mechanism in the a= tag to retrieve the validated hash.

2. Compute the hash of the logo in the l= tag.

3. If the hash of the logo does not match the validated hash, then logo validation has failed and then indicator MUST NOT be displayed.

4. If the hashes match, and the validated hash is from a trusted source, then the indicator can be displayed per receiver policy.

Affix BIMI status to Authentication Results header field {#bimi-results}
----------------------------------

Upon completion of Indicator Discovery, an MTA SHOULD affix the result in the Authentication-Results header using the following syntax, with the following key=value pairs:

bimi: Result of the bimi lookup (plain-text; REQUIRED). Range of values are 'pass' (BIMI successfully validated), 'none' (no BIMI record present), 'fail' (syntax error in the BIMI record, or some other error), 'temperror' (DNS lookup problem), or 'skipped' (BIMI check did not perform, possibly because the message did not comply with the minimum requirements such as passing DMARC, or the MTA does not trust the sending domain). The MTA MAY put comments in parentheses after bimi result, e.g., "bimi=skipped (sender not trusted)" or "bimi=skipped (message failed DMARC)".

header.d: Domain used in a successful BIMI lookup (plain-text; REQUIRED if bimi=pass). If the first lookup fails for whatever reason, and the second one passes (e.g., using the organizational domain), the organizational domain should appear here. If both fail (or have no record), then the first domain appears here.

selector: Selector used in a successful BIMI lookup (plain-text; REQUIRED if bimi=pass). Range of values include the value in the BIMI-Selector header, and 'default'. If the first lookup fails (or has no record) and second passes, the second selector should appear here. If both fail (or have no record), then the first selector should appear here.

Handle Existing BIMI-Location Headers
---------------

Regardless of success of the BIMI lookup, if a BIMI-Location header is already present in a message it MUST be either removed or renamed.  This is because the MTA performing BIMI-related processing immediately prior to a Mail Delivery Agent (or within the same administrative realm) is the only entity allowed to specify the BIMI-Location header (e.g. not the sending MTA, and not an intermediate MTA).  Allowing one or more existing headers through to a MUA is a security risk.

If the original email message had a DKIM signature, it has already been evaluated. Removing the BIMI-Location header at this point should not break the signature since it should not be included within it per this spec.

Construct BIMI-Location URI(s)
---------------

The l= value of the BIMI-Location header is a comma separated list of URIs to Indicators the MTA believes are most applicable to its MUAs. From the options provided by the Assertion Record, MTAs SHOULD choose the Indicators to include based on Receiver policy for optimal performance, safety, and user experience.  

MTAs MAY add as many comma separated URIs to the l= tag in the BIMI-Location header as they wish, MUAs MUST support at least 2 location URIs in the header, and MAY support more.

Set appropriate flags on the mail store {#mail-stores}
----------------------------------

Once an MTA has completed BIMI-related processing for a message, generic message processing continues so that the intended recipient(s) can eventually access the message with an MUA. Users typically access their email stored on mail stores through either POP3, IMAP, and MAPI. Separate documents will define protocol-specific BIMI extensions for mail stores.

If a mail store is BIMI-compliant, the MTA SHOULD set a flag on the message when depositing in the mail store. This is to communicate between the MTA and its MUA that the BIMI-Location header was set locally and can be trusted.

If an MUA has a BIMI-compliant mail store, and no appropriate flag is set, the MUA SHOULD ignore the BIMI-Location header.

If a mail store ingests a message from another mail store through some other means, the ingesting mail store may or may not set the protocol-specific BIMI flag when it pulls down the relayed message. If it trusts the other mail store, it may simply set the same flag. Or, it may re-evaluae BIMI policy and requirements, create or replace the BIMI-Location header, and set its own flag appropriately. Or, it may simply choose not to set the flag at all.

Security Considerations   {#security-considerations}
===================

The consistent use of brand indicators is valuable for Domain Owners, Mail Receivers, and End Users. However, the routine display of brand indicators represents an attractive target for abuse, especially for determined malicious actors.  Great care is warranted.  The discussion following as an incomplete list of considerations.  

Lookalike Domains and Copycat Indicators
------------

Publishing BIMI records is not sufficient for an MTA to signal to the MUA to load the BIMI indicator.  For example, the Domain Owner may also need to have a sufficiently strong reputation with the MTA.  The receiver may use a manually maintained list of large brands, it may import a list from a third party of acceptable domains, or it may apply its own reputation heuristics before deciding whether or not to load the BIMI indicator.  BIMI does not specify what MTAs may bring 
to bear as additional factors.  

Large files and buffer overflows
------------

The MTA or MUA should perform some basic analysis and avoid loading indicators that are too large or too small.  The Receiver may choose to maintain a manual list and do the inspection of its list offline so it doesn't have to do it at time-of-scan.

Slow DNS queries
------------

All email Receivers already have to query for DNS records, and all of them have built-in timeouts when performing DNS queries.  Furthermore, the use of caching when loading images can help cut down on load time.  Virtually all email clients have some sort of image-downloading built-in and make decisions when to load or not load images.

Unaligned indicators and asserting domains
------------

There is no guarantee that a group responsible for managing brand indicators will have access to put these indicators directly in any specific location of a domain, and requiring that indicators live on the asserted domain is too high a bar.  Additionally, letting a brand have indicator locations outside its domain may be desirable so that someone sending legitimate authenticated email on the Domain Owner's behalf can manage and set selectors as an authorized third party without requiring access to the Domain Owner's DNS or web services.

Unsigned BIMI-Selector Header
------------

If a Domain Owner relies on SPF but not DKIM for email authentication, then adding a requirement of DKIM may create too high of a bar for that sender.  On the other hand, Receivers doing BIMI assertion may factor in the lack of DKIM signing when deciding whether to add a BIMI-Location header.

CGI scripts in Indicator payload
------------

MTAs and MVAs should aggressively police Indicators to ensure they are the Indicators they claim to be, are within appropriate size limits, and pass other sanity checks. Additionally, MTAs might cache good Indicators and serve them directly to their MUAs, which would in practice bypass any malicious dynamic payload set to trigger against an end user but not an MTA.

Metadata in Indicators
------------

Domain Owners should be careful to strip any metadata out of published Indicators that they don't want to expose or which might bloat file size. MTAs and MVAs might wish to inspect and remove such data from Indicators before exposing them to end users.

IANA Considerations   {#iana}
===================

IANA will need to reserve two new entries for the "Permanent Message Header Field Names" registry and create a registry for support file formats for BIMI.

Permanent Header Field Updates
------------

IANA will need to reserve two new entries to the "Permanent Message Header Field Names" registry.

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

Registry for Support BIMI Formats
------------

Names of support file types supported by BIMI must be registered by IANA.

New entries are assigned only for values that have been documented in a published RFC that has had IETF Review, per [IANA-CONSIDERATIONS]. Each method must register a name, the file extension, the specification that defines it, and a description.

Other IANA needs
------------

NOTE TO WORKING GROUP: The registry for BIMI tags needs to be properly set up, as does the registry for validation actions.

--- back

Example Selector Discovery (INFORMATIVE) {#bimi-header-examples}
===================

This section shows several examples of how a receiving MTA should determine which Assertion Record to use depending on the BIMI-Selector header.

No BIMI-Selector Header
----------

The domain example.com does not send with a BIMI-Selector header.

    From: sender@example.com

The MTA would lookup default._bimi.example.com for the BIMI DNS record.

With BIMI-Selector Header
------------

The domain example.com sends with a BIMI-Selector header:

    From: sender@example.com
    BIMI-Selector: v=BIMI1; s=selector;

The MTA would lookup selector._bimi.example.com.

Without BIMI-Selector Header on a subdomain
------------

The domain foo.example.com sends without a BIMI-Selector header:

    From: sender@foo.example.com
    
The MTA would lookup default._bimi.foo.example.com for the BIMI DNS record. If it did not exist, it would lookup default._bimi.example.com.

With BIMI-Selector Header on a subdomain
------------

The domain foo.example.com sends without a BIMI-Selector header:

    From: sender@foo.example.com
    BIMI-Selector: v=BIMI1; s=selector;
    
The MTA would lookup selector._bimi.foo.example.com for the BIMI DNS record. If it did not exist, it would fall back to the lookup default._bimi.example.com.

Invalid BIMI-Selector Header
---------

The domain example.com sends with a BIMI-Selector header, but does not include the required field 'v=':

    From: sender@example.com
    BIMI-Selector: s=selector;

The MTA would ignore this header, and lookup default._bimi.example.com.

Example Authentication-Results entry (INFORMATIONAL)   {#ar-examples}
=============

This section shows example Authentication-Results stamps based on different BIMI lookup statuses.

Successful BIMI lookup
-------------

    From: sender@example.com
    BIMI-Selector: v=BIMI1; s=selector;
    Authentication-Results: bimi=pass header.d=example.com selector=selector;

No BIMI record
--------------

    From: sender@sub.example.com
    Authentication-Results: bimi=none;

In this example, sub.example.com does not have a BIMI record at default._bimi.sub.example.com, nor does default._bimi.example.com

Subdomain has no default record, but organizational domain does
----------------

    From: sender@sub.example.com
    Authentication-Results: bimi=pass header.d=example.com selector=default;

Subdomain has no record for selector, but organization domain has a default
---------------

    From: sender@sub.example.com
    BIMI-Selector: v=BIMI1; s=selector;
    Authentication-Results: bimi=pass header.d=example.com selector=default;

In this example, the sender specified a DNS record at selector._bimi.sub.example.com but it did not exist. The fallback is to use default._bimi.example.com, not selector._bimi.example.com even if that record exists.


Example BIMI-Location Construction (INFORMATIONAL)   {#bimi-location-example}
===============

This section shows how an example MTA might evaluate an incoming email for BIMI participation, and how it could share that determination with its MUA(s).

MTA Receives an email
-----------------

The MTA receives the following DKIM signed message:

    DKIM-Signature: v=1; s=myExample; d=example.com; h=From;BIMI-Selector;Date;bh=...;b=...
    From: sender@example.com
    BIMI-Selector: v=BIMI1; s=brand;
    BIMI-Location: image.example.com/bimi/logo/example-bimi.svg
    Subject: Hi, this is a message from the good folks at Example Learning

MTA does its authentication checks
------------------

The receiving MTA receives the message and performs an SPF verification (which fails), a DKIM verification (which passes), and a DMARC verification (which passes). The domain is verified and has good reputation. The Receiver proceeds to perform a BIMI lookup.

MTA performs BIMI Assertion
------------------

The MTA sees that the message has a BIMI-Selector header, and it is covered by the DKIM-Signature, and the DKIM-Signature that passed DKIM is the one that covers the BIMI-Selector header. The MTA sees the header validates and contains 'v=BIMI1', and 's=brand'. It performs a DNS query for brand._bimi.example.com and retrieves:

    brand._bimi.example.com IN TXT "v=BIMI1; l=https://image.example.com/bimi/logo/"

The MTA verifies the syntax of the BIMI DNS record, and it, too passes.

MTA appends to Authentication-Results
-----------------

The MTA computes and affixes the results of the BIMI to the Authentication-Results header:

    Authentication-Results: spf=fail smtp.mailfrom=example.com;
      dkim=pass (signature was verified) header.d=example.com;
      dmarc=pass header.from=example.com;
      bimi=pass header.d=example.com selector=brand;

MTA Constructs BIMI-Location header
-----------------

The MTA knows it has cached the indicator already, and wishes to use this cached indicator instead of a direct reference to the l= tag.

Finally, the MTA removes the existing BIMI-Location header, and stamps the new one:

    BIMI-Location: v=BIMI1; l=https://cache.mta.example/bimi/logo/bimi-example.com-sel-brand.svg

That the original sender signed a BIMI-Location header against this spec is irrelevant. It was used for DKIM validation and then thrown out by the MTA.

The MTA then sets any relevant BIMI flags on the mail store when it deposits it.

The MUA displays the indicator
---------------

The mail is opened from the mail store in an MUA. The MUA checks to make sure the appropriate BIMI mail store flag has been set, so that it knows it can trust the BIMI-Location header. Finally, the MUA makes a simple determination of which image to show based upon the URI(s) in the BIMI-Location header.

Acknowledgements 
------------
Many people have contributed to the development of BIMI.  Along with thanks to members of the current Authindicators Working Group, the editors wish to acknowledge the efforts of Sri Somanchi, Don Cardinal, Steve Jones, and John Levine.  


