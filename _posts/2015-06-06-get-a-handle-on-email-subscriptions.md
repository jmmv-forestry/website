---
layout:      post
title:       Get a handle on email subscriptions
date:        2015-06-06 12:00:00
categories:  best-practices email essay workflow
medium:      get-a-handle-on-email-subscriptions-137a7472d71d
cover-image: 2015-06-06-header.jpg
---

Do you have any idea which online services and stores have you given your email address to? Are you able to quantify the effort it would take to fully migrate to a different email account if you ever wanted to?

(Cover image courtesy of <http://www.startupstockphotos.com/>)

* * *

Three years ago, I was not able to answer these two simple questions when I decided to move my email account to our new family-owned domain.  Today? I trivially can, and so can you.

The process to track the services you have registered to is a rigorous but easy one: **the key idea is to define filters to label the messages of each individual subscription with the name of the service they belong to.** Doing this leaves you with a collection of labels that represents the set of services you have handed your email address out to. As an added benefit, you will also always be able to know _why_ a certain piece of email is reaching your inbox&mdash;and possibly help cut down unsolicited email.

The practical aspects in this post are for GMail but don't let that shy you away from reading: the theory and processes described in here apply equally to all major email providers including Outlook.com and Apple's iCloud.

# Say hello to address tags

_(also known as sub-addressing or plus-addressing)_

A little known feature of various email providers is their support of [address tags](http://en.wikipedia.org/wiki/Email_address#Address_tags). As the Wikipedia describes them:

> Some mail services allow a user to append a tag to their email address
(e.g., where `joeuser@example.com` is the main address, which would also accept mail for `joeuser+work@example.com` or `joeuser-family@example.com`).  The text of _tag_ may be used to apply filtering and to create _single-use_ addresses. [...]

> [Disposable email
addresses](http://en.wikipedia.org/wiki/Disposable_email_address) of this form, using various separators between the base name and the tag, are supported by several email services, including [Runbox](http://en.wikipedia.org/wiki/Runbox) (plus), [Gmail](http://en.wikipedia.org/wiki/Gmail) (plus), [Yahoo! Mail Plus](http://en.wikipedia.org/wiki/Yahoo!_Mail) (hyphen), Apple's [iCloud](http://en.wikipedia.org/wiki/ICloud) (plus), [Outlook.com](http://en.wikipedia.org/wiki/Outlook.com) (plus), [FastMail](http://en.wikipedia.org/wiki/FastMail) (plus and [Subdomain Addressing](http://www.fastmail.fm/help/features_plus_addressing_and_subdomain_addressing.html)), and [MMDF](http://en.wikipedia.org/wiki/MMDF) (equals).

To paraphrase the above: **address tags supply you with an unlimited number of email addresses**, all of which are delivered to the account you already own and check periodically. Address tags are a key feature in _tracking where email comes from_ and are also somewhat useful in _combating spam_.

Try it now! Go to your GMail account, compose a new email, and send it to yourself after adding `+test` right before the `@` sign. Then witness how the email reaches your own inbox without issues. What's more: if you click the little arrow next to the delivery address in the message view, you will notice the difference between the _from_ and _to_ addresses and how the difference is respected even after delivery to your inbox:

<img src="/images/2015-06-06-gmail-plus-address.png"
     alt="GMail plus addressing in action"
     class="block" />

Let me emphasize that last point because it is important: any tag added to your address is kept as part of the _to_ field of the message recorded in your mailbox. Ergo you can use this value for filtering.

## Using address tags for email filtering

The way to use address tags for better email subscription tracking is to use a new tag&mdash;hence a unique email address&mdash;for each service you subscribe to.

For example: use `joe+medium@example.com` when registering for an account on Medium instead of the plain `joe@example.com` address. By doing this, any email sent by Medium to you would be _delivered to_ this special address regardless of the address Medium uses to send their correspondence _from_.

However, if you _only_ do the above, you won't _see_ a difference: all email from Medium will show up in your inbox as usual. The trick is to classify such email using filters and to base those filters on the new tag.

# The process

Now that you know what address tags are and how they work, it is time to put them into practice to equip you with a mechanism to track where each piece of email comes from.

Do this:

1. Every time you hand out your email address to any service&mdash;be it an online site or a local physical store&mdash;append the name of the service or store as a tag to your address. Never hand out your untagged address if you can avoid it.
1. Immediately after handing out your address, go to your email account and set up a new filter to label all incoming email from that service with a label that matches the service name. Continuing with GMail as our sample email provider, you would set up a filter to classify all email with the expression `deliveredto:joe+medium@example.com` and make the filter tag those emails with a label of the form `Subscriptions/medium`:

<img src="/images/2015-06-06-deliveredto-filter.png"
     alt="Defining a deliveredto: based filter in GMail"
     class="block" />

Voil&agrave;! That's it. By being diligent this way, over time, your collection of labels under Subscriptions will grow and it will accurately track all the services you would need to update if you were ever going to move your email account to a different provider.

## The exception... there always is an exception

Unfortunately, some services _do not support_ plus-addresses even though the plus sign is perfectly recognized by email standards (e.g. [RFC 6531](http://tools.ietf.org/html/rfc6531), [RFC 6532](http://tools.ietf.org/html/rfc6532), and [RFC 5233](https://tools.ietf.org/html/rfc5233)). For those services, you will have to hand out your real email address and then set up filters to label incoming email based on the address&mdash;or addresses&mdash;the service uses to send messages to you.

Do not bother contacting support for any of the services that reject plus signs in email addresses; it is futile. I have tried in a handful of occasions and never got a positive acknowledgement of a bug. Canned responses&mdash;which you will get&mdash;feel particularly disrespectful.

## Is it too late for you?

The process above was trivial for me to implement three years ago because I religiously applied it after starting afresh with a new email address. But what if you are not getting a new email address? Can you still apply these techniques to your existing account? Sure you can, but it will take longer and you may miss some subscriptions.

Do this: every time you receive an email that does not come from an individual &mdash;that is, an email that is not from a family member, from a friend, or from any other _person_&mdash;visit the site that sent the email, change your email address to use a new address tag, and then set up a filter to label the email accordingly.

The downside of this process is that it may take months for you to reach a point where the majority of your subscriptions are properly tagged&mdash;and even then, you may still be missing that odd corner case (see next section).

Regardless, _start now_: the added benefit is worthwhile and you will be glad you did so in the future.

## Tracking the odd subscription before it is too late

Last week, I tried to regain access to my old Dropbox account only to realize that I had signed up with an email address I no longer own&mdash;an address on a domain that no longer exists. I had forgotten to transfer this subscription to my new email address before the old one expired, and so I have lost access to my account forever. Oops.

Not a big deal in this particular case, but this example highlights how important it is for you to keep track of all the services you have subscribed to using your email address: if you ever change email providers, you'll want to upgrade your services as soon as possible to prevent losing access to them.  Doing these changes en masse is only feasible if you have a record of all places that need to be updated!

# A note on spam

<img src="/images/2015-06-06-gmail-labels.png"
     alt="Sample GMail labels"
     class="float-right with-border" />

I have mentioned spam protection a few times in this post, but why would any of this help you combat spam? The truth is: none of this helps you _prevent_ spam, but it helps you _spot untrustworthy services_.

The rationale: **if you create a different email address every time you hand it out, only the recipient of that address should be able to send you messages to that unique address**. Therefore, if you suddenly start receiving unexpected messages via that unique address, it will be clear that the service either sold your address (bad) or leaked it as part of a security breach (worse).

The way you'll notice whether a specific tagged email address has been leaked will depend on your email provider. In the case of GMail, the way I notice is by visiting the _Spam_ folder and looking for any email with labels that start with _Subscription/_. (On email providers with real folders, you will see junk appearing on the various subfolders you have defined instead.)

Is this effective? Yes&mdash;two major brands have lost my trust&mdash;but address tags are _not_ bulletproof. The rules behind address tags are well-known for all major email providers, so it is simple for spammers to strip out the tags in an attempt to hide where they got their addresses from. That said, and considering that the feature of address tags is not known at all by the majority, it's still a reasonable way of catching untrustworthy online services.

Want to make the solution bullet-proof? Run your own email server with real unique and disposable addresses (not sub-addresses) but then you get to manage your own server. Yikes; not worth the hassle.
