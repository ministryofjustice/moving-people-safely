# Changelog
## 2019-01-09
<!-- Merged PRs since last release:

Merge time            Author                PR  Branch
----------------------------------------------------------------------
2018-11-27 09:40:21   Cesidio Di Landa      618 refactor-formbuilder
2018-11-27 14:21:38   Andy White            616 police-no-offence-reuse
2018-11-28 11:56:07   Andy White            617 police-healthcare-inconsistencies
2018-11-28 13:27:35   Andy White            611 remove-police-cell-share-question
2018-11-28 15:43:32   Andy White            619 court-dashboard-label-mods
2018-11-29 11:50:59   Andy White            624 bold-dashboard-surnames
2018-11-29 12:13:14   Andy White            621 missing-approver-details-bug
2018-11-29 13:04:39   Andy White            620 remove-female-hygiene-kit-details
2018-11-29 13:35:32   Andy White            632 inconsistent-dashboard-column-widths
2018-11-29 14:08:27   Andy White            636 dashes-for-blanks
2018-11-29 15:31:13   Matthew Rudy Jacobs   637 nicer-tempfile-names
2018-11-29 16:18:29   Matthew Rudy Jacobs   599 better-pdf-name
2018-11-30 14:30:11   Cesidio Di Landa      638 refactor-form-builder
2018-12-01 12:20:23   Cesidio Di Landa      642 add-slim-lint
2018-12-03 13:00:35   Cesidio Di Landa      643 add-scss-lint
2018-12-03 17:06:50   Cesidio Di Landa      645 fix-multiples
2018-12-04 14:34:30   Cesidio Di Landa      646 improve-rubocop
2018-12-04 17:39:07   Cesidio Di Landa      648 minor-improvements-form-builder
2018-12-04 17:46:13   Cesidio Di Landa      649 fix-return-establishments
2018-12-05 11:56:55   Cesidio Di Landa      647 fix-observations-levels
2018-12-05 12:38:27   Matthew Rudy Jacobs   654 ruby-2.5.3
2018-12-09 19:13:53   Cesidio Di Landa      656 refactor-buttons
2018-12-10 12:53:21   Cesidio Di Landa      660 update-govuk-framework
2018-12-10 14:37:36   Andy White            661 fix-feature-detainee-ages
2018-12-11 12:30:07   Andy White            664 approved-on-new-line
2018-12-11 16:21:03   Cesidio Di Landa      665 cleanup-move-form
2018-12-12 12:04:08   Cesidio Di Landa      666 use-active-model-for-simple-forms
2018-12-13 15:38:30   Cesidio Di Landa      668 cleanup-reform
2018-12-13 18:42:25   Cesidio Di Landa      669 fix-seed-custody
2018-12-13 19:07:13   Cesidio Di Landa      670 add-healthcare-contact-number
2018-12-18 12:45:15   Cesidio Di Landa      677 change-pnc-validation
2018-12-19 13:04:14   Andy White            683 i18n-all-text
2019-01-07 16:00:55   Andy White            663 rename-rule45
2019-01-07 16:11:03   Cesidio Di Landa      697 run-linters-in-circle
2019-01-08 14:28:50   Cesidio Di Landa      705 ruby-2.6
2019-01-08 14:33:22   Andy White            684 clarify-offences-form
2019-01-09 13:11:00   Andy White            698 details-on-all-observation-levels
-->
### Changed
- Improved performance of forms. <!-- PR 618, PR 638 refactor-form-builder, PR 648 minor-improvements-form-builder, PR 666 use-active-model-for-simple-forms, PR 665 cleanup-move-form, PR 668 cleanup-reform, PR 645 fix-multiples -->
- Improved usability of offences form. <!-- PR 684 clarify-offences-form -->
- Improved consistency of healthcare questions. <!-- PR 617 -->
- Improved consistency of all text in field labels and hints. <!-- PR 683 i18n-all-text -->
- No longer re-use offences on police PER. <!-- PR 616 -->
- Removed cell share question on police PER. <!-- PR 611 remove-police-cell-share-question -->
- Improvements to court dashboard labels. <!-- PR 619 court-dashboard-label-mods -->
- Improvements to PER dashboard layout. <!-- PR 624 bold-dashboard-surnames, PR 632 inconsistent-dashboard-column-widths -->
- Removed details field for female hygiene kit question. <!-- PR 620 remove-female-hygiene-kit-details -->
- Improved summary PER display. <!-- PR 636 dashes-for-blanks -->
- Improved display of approver details. <!-- PR 664 approved-on-new-line -->
- Rename rule 45 question for prison PER. <!-- PR 663 rename-rule45 -->
- Improved usability of observation level question in police PER. <!-- PR 647 fix-observations-levels, PR 698 -->
- Enlarged establishment details field. <!-- PR 649 fix-return-establishments -->
- Update of code libraries to improve performance and security. <!-- PR 654 ruby-2.5.3, PR 660 update-govuk-framework, PR 642 add-slim-lint, PR 643 add-scss-lint, PR 646 improve-rubocop, PR 697 run-linters-in-circle, PR 705 ruby-2.6 -->

### Fixed
- Fixed bug where approver details were sometimes not displayed. <!-- PR 621 missing-approver-details-bug -->
- Fixed faulty validation of PNC numbers. <!-- PR 677 change-pnc-validation -->
- Fixed bug where printed PER sometimes did not appear in a separate tab. <!-- PR 599 better-pdf-name -->

## 2018-11-26
<!-- Merged PRs since last release:
 Use: git log --pretty="format:%h %ci (%an) %d %s" --decorate=full | grep Merge

 Merge date  Author               PR  Branch/Description
 ----------------------------------------------------------------------
 2018-11-19  Cesidio Di Landa     608 Bump aws-sdk-s3 from 1.23.1 to 1.24.1
 2018-11-19  Cesidio Di Landa     609 Bump uglifier from 4.1.19 to 4.1.20
 2018-11-19  Cesidio Di Landa     601 Bump regexp_parser from 1.2.0 to 1.3.0
 2018-11-19  Cesidio Di Landa     607 Bump capybara from 3.10.1 to 3.11.1
 2018-11-19  Cesidio Di Landa     588 Bump sass from 3.6.0 to 3.7.2
 2018-11-21  Andy White           594 Changes to the ePER questions for women's estate
 2018-11-22  Andy White           603 Improve mapping of NOMIS ethnicity to MPS
 2018-11-23  Andy White           610 Change police questions and hints
 2018-11-23  Cesidio Di Landa     613 Bump aws-partitions from 1.114.0 to 1.115.0
 2018-11-23  Cesidio Di Landa     615 Bump aws-sdk-core from 3.38.0 to 3.39.0
 2018-11-23  Cesidio Di Landa     614 Bump aws-sdk-kms from 1.11.0 to 1.12.0
 2018-11-23  Cesidio Di Landa     612 Bump aws-sdk-s3 from 1.24.1 to 1.25.0
-->
### Changed
- Improvements to questions related to women detainees on the police ePER. <!-- PR 594 -->
- Improvements to labels and hints on some police ePER questions. <!-- PR 610 -->
- Update of code libraries to improve performance and security. <!-- PR 608 609 601 607 588 613 615 614 612 -->

### Fixed
- Fixed a bug where ethnicity codes from NOMIS were not automatically populating the detainee form. <!-- PR 603 -->


## 2018-11-19
<!-- Merged PRs since last release:

 Merge date  Author               PR  Branch/Description
 ----------------------------------------------------------------------
 2018-11-19  Andy White           604 Update changelog
 2018-11-15  Andy White           595 ie8-start-page-banner
 2018-11-15  Andy White           597 breadcrumb-bug
 2018-11-14  Matthew Rudy Jacobs  596 pdf-download-filename
 2018-11-14  Matthew Rudy Jacobs  598 gemfile-github
 2018-11-12  Cesidio Di Landa     591 dependabot/bundler/pry-0.12.2
 2018-11-12  Cesidio Di Landa     587 dependabot/bundler/aws-sdk-core-3.37.0
 2018-11-12  Cesidio Di Landa     586 dependabot/bundler/thor-0.20.3
 2018-11-12  Cesidio Di Landa     585 dependabot/bundler/aws-partitions-1.111.0
 2018-11-12  Cesidio Di Landa     583 clean-assets
 2018-11-12  Cesidio Di Landa     584 fix-pnc-details
 2018-11-08  Andy White           569 police-suicide-question
 2018-11-08  Cesidio Di Landa     577 bundle-update-layout
 2018-11-07  Andy White           571 fix-pregnancy-bug-fix
 2018-11-07  Cesidio Di Landa     578 bundle-update-rack
 2018-11-06  Cesidio Di Landa     575 interpreter-required-police
 2018-11-05  Cesidio Di Landa     576 bundle-update-5-11-18
 2018-10-31  Andy White           568 update-changelog
 2018-10-31  Cesidio Di Landa     573 improve-form-builder
 2018-10-30  Matthew Rudy Jacobs  567 circle-store-test-results
 2018-10-30  Cesidio Di Landa     572 remove-useless-gems
 2018-10-29  Cesidio Di Landa     570 detainee-mandatory-fields
 2018-10-16  Andy White           565 distinct-nomis-error-messages
 2018-10-16  Andy White           566 fix-pregnant-not-displaying
-->
### Changed
- Improved consistency of error messages from NOMIS. <!-- PR 565 -->
- Improved validation of detainee form fields. <!-- PR 570 -->
- Optimisation of forms to increase performance and reliability. <!-- 573 584 -->
- Addition of police ePER observation level questions. <!-- 569 -->
- Simplified saving of PDF with a sensible filename. <!-- 596 -->
- Update of code libraries to improve performance and security. <!-- PR 572 576 578 577 585 586 587 591 598 583 -->
- Improvements to automated testing to increase code quality. <!-- PR 567 -->
- Improvements to interpreter question for police ePERs. <!-- 575 -->
- Introduced a warning if IE8 browser used. <!-- PR 595 -->

### Fixed
- Fixed a bug where pregnancy details were not displayed correctly. <!-- PR 566 571 -->
- Fixed a bug where page breadcrumbs were not displaying correctly. <!-- PR 597 -->


## 2018-10-11
<!-- Merged PRs since last release:
   PR   Merge date   Commit    Author                Branch
 --------------------------------------------------------------------------------
  564   2018-10-11   9d4ed87   Andy White            remove-religion-from-police
  534   2018-10-11   e27d55b   Andy White            remove-cat-a-question
  562   2018-10-04   843bb7f   Andy White            special-move-reqs-questions
  563   2018-10-04   65a6166   Matthew Rudy Jacobs   fix-should-matchas
  561   2018-10-02   a13d896   Matthew Rudy Jacobs   circleci-local
  552   2018-09-27   c1f63c6   Matthew Rudy Jacobs   spec-add-path-assertions
  551   2018-09-27   d5a93ed   Matthew Rudy Jacobs   risk-cache-in-tmp
  557   2018-09-27   4fda395   Matthew Rudy Jacobs   add-licence
  554   2018-09-27   1821b30   Matthew Rudy Jacobs   omniauth-log-to-rails-logger
  553   2018-09-27   45f7634   Matthew Rudy Jacobs   quiet-compare-spec
-->
### Changed
* Detainee religion field removed for police PER. <!-- PR 564 -->
* Security category moved from risks to detainee section for prison PER. <!-- pr 534 -->
* Security category populated from NOMIS if available. <!-- PR 534 -->
* Changes to PDF printout for police PER. <!-- PR 534 -->
* Add special vehicle details to move section. <!-- PR 562 -->
* Improvements to internal quality and testing systems. <!-- PRs 551, 552, 553, 561, 563 -->

### Fixed
* Fix bug where Dependencies were not bold in the PDF printout. <!-- PR 534 -->


## 2018-09-27
<!-- Merged PRs since last release:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------
  560   2018-09-27   0261766   Cesidio Di Landa      copy-changes
  555   2018-09-27   aed7011   Andy White            ethnic-codes-type-ahead
  559   2018-09-27   cbe1df5   Andy White            add-medway-police-station
  558   2018-09-27   a91bfcf   Andy White            fix-automation-report
  541   2018-09-25   cb92e46   Andy White            nomis-down-detainee-bug
-->
### Changed
* Improved field hints for Self harm details and Approve confirmation. <!-- PR 560 -->
* Replace detainee ethnicity field with a type-ahead using standard 16+1 ethnicity list. <!-- PR 555 -->
* Medway Police Station added to list of Police custody suites. <!-- 559 -->

### Fixed
* Fix a bug where an error was presented if detainee was left incomplete. <!-- PR 541 -->
* Fix a bug with internal reporting. <!-- PR 558 -->


## 2018-09-25
<!-- Merged PRs since last release:
   PR   Merge date   Commit    Author                Branch
 --------------------------------------------------------------------------------------
  549   2018-09-25   fa5bd6e   Cesidio Di Landa      amend-police-questions
  548   2018-09-20   7c21e16   Andy White            remove-detainee-security-category
  547   2018-09-20   acb5051   Andy White            automated-risk-v2-automation-view
  545   2018-09-20   ef1b375   Cesidio Di Landa      risk-before-start
  546   2018-09-20   3bdd948   Andy White            update-rubyzip-gem
  544   2018-09-20   c590c94   Andy White            automated-risk-v2
  539   2018-09-04   fd66dde   Andy White            conditional-alert-tags
  538   2018-08-30   82c3eb4   Andy White            audit-events
  542   2018-08-29   44bdaf0   Cesidio Di Landa      update-gems
  540   2018-08-29   1433dff   Cesidio Di Landa      circle2
  524   2018-08-28   9e02bc3   Andy White            police-custardy-suite-validation
-->
### Changed
* Enhancements to police ePER risk questions. <!-- PR 549 -->
* Add intro to police ePER risks assessment section. <!-- PR 545 -->
* Improve display of alerts so that only relevant ones are displayed. <!-- PR 539 -->
* Introduce auditing of PER views and printing to enhance security. <!-- PR 538 -->
* Improve internal reporting system. <!-- PR 544 -->
* Internal security updates. <!-- PR 542, 540, 546 -->

### Fixed
* Fixed bug where police custody suite could be left blank for police users. <!-- PR 524 -->


## 2018-08-21
<!-- Merged PRs prior to this release:
   PR   Merge date   Author         Details
 ------------------------------------------------------------------------------
  536   2018-08-20   Andy White     new-error-content-v3
  533   2018-08-14   Clive Murray   Make sticky js class generic and add it to help menu
  532   2018-08-13   Andy White     rename-west-cumbria
  526   2018-08-13   Andy White     update-sex-field
  525   2018-08-13   Andy White     new-error-content-v2
  531   2018-08-10   Andy White     improve-help-page
  530   2018-08-09   Clive Murray   CSS hackery to get the search button inline with the search field
  529   2018-08-08   Clive Murray   Flowplayer videos for all browsers
  527   2018-08-07   Clive Murray   Fix bug that causes JS errors on other pages than help
  528   2018-08-07   Clive Murray   Trigger GOV.UK details.polyfill for IE
  523   2018-08-07   Clive Murray   Flowplayer videos
-->
### Changed
* Improvements to form elements and layout. <!-- PR 527, 528, 533 -->
* Renamed West Cumbria Magistrates Court. <!-- PR 532 -->
* Improvements to labels and helper text. <!-- PR 525, 526 -->
* Improvements to functionality and display of help screen. <!-- PR 523, 529, 531 -->
* Improvements to positioning of ePER search button. <!-- PR 530 -->

### Fixed
* Fix missing and incorrect error message across various forms. <!-- PR 536 -->


## 2018-07-31
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Author                Details
 -------------------------------------------------------------------------------------
  522   2018-07-31   Andy White            rename-salfords-2
  517   2018-07-27   Andy White            police-medical-contact-lables
  513   2018-07-26   Andy White            bigger-pnc-textarea
  520   2018-07-26   Clive Murray          JS polyfill for sticky sidebar in IE9+
  519   2018-07-24   Cesidio Di Landa      sergeant-role
  518   2018-07-24   Clive Murray          Found an even better favicon which will look nice on all devices
  515   2018-07-18   Andy White            add-copy-lane-and-salfords-to-police-list
  516   2018-07-18   Cesidio Di Landa      sergeant
  500   2018-07-16   Andy White            italicised-alerts-in-hint-text-bug
  507   2018-07-16   Andy White            traffic-drugs-details
  512   2018-07-13   Clive Murray          MOJ crest favicon replaces GOV.UK crest favicon
  509   2018-07-13   Cesidio Di Landa      align-prison-police-alerts
  511   2018-07-13   Cesidio Di Landa      show-issued-escorts
  510   2018-07-12   Clive Murray          Remove ga.js and replace with google tag manager
  508   2018-07-12   Clive Murray          Override NTA font throughout with Arial... ugh
  504   2018-07-11   Cesidio Di Landa      mandatory-details-interpreter
  505   2018-07-11   Cesidio Di Landa      csra-details-police
  502   2018-07-10   Clive Murray          header-link-colour
  501   2018-07-10   Clive Murray          real-label-for-datepicker
  506   2018-07-10   Clive Murray          Fix datepicker radio label alignment
  503   2018-07-10   Clive Murray          Apply usual styling to datepicker radios
  493   2018-07-05   Cesidio Di Landa      sections-config
  498   2018-07-04   Andy White            add-medical-phone-number-altcourse
  497   2018-07-04   Andy White            harasser-intimidator-error-message
  499   2018-07-03   Andy White            move-destination-prefill-bug
  495   2018-07-03   Andy White            landing-page-police-welcome
  496   2018-07-02   Andy White            update-sprockets
-->
### New
* Add sergeant approval process to police ePER workflow. <!-- PR 519, 516 -->

### Changed
* Improvements to police ePER workflow: new and updated questions, new police landing page <!-- PR 493 504 507 495 -->
* Improve harassment & gangs error messages. <!-- PR 497 -->
* Improve visibility of issued ePERs. <!-- PR 511 -->
* Improve MoJ crest favicon. <!-- PR 512, 518 -->
* Layout improvements on field labels, field sizes, hint text, & alerts <!-- PR 517 513 500 508 509 501 506 505 503 520 -->
* Better analytics monitoring to improve data for future enhancements. <!-- PR 510 -->
* Update code libraries to increase security. <!-- PR 496 -->
* Update police custody and prison establishment lists. <!-- PR 522 515 497 -->


## 2018-06-20
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------------------------
  492   2018-06-20   8503de5   Andy White            common-destination-list
  488   2018-06-19   4f6d369   Andy White            police-not-for-release-reason-list-v2
  491   2018-06-19   fcfb46b   Cesidio Di Landa      police-detainee-form
  490   2018-06-13   d8617c2   Andy White            update-self-harm-question-v2
  489   2018-06-13   b228a07   Andy White            add-brighton-crown-court-v2
  487   2018-06-13   97857ce   Cesidio Di Landa      police-search-new
  486   2018-06-11   d91e281   Cesidio Di Landa      filter-charges-NEW
  480   2018-06-04   f8ba2d9   Cesidio Di Landa      help-videos-page
-->
### New
* Added youth secure estates, police custody suites and immigration removal centres to move destinations. <!-- PR 492 -->
* Added search functionality for police users. <!-- PR 487 -->
* Added help pages with videos to assist users. <!-- PR 480 -->

### Changed
* Customise detainee form to provide dedicated functionality for police and prison. <!-- PR 491 -->
* Separated not for release reason lists for police and prison. <!-- PR 488 -->
* Improved filtering of offences from NOMIS API. <!-- PR 486 -->
* Improved text for self harm question. <!-- PR 490 -->
* Additions to destination list. <!-- PR 498 -->


## 2018-05-30
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------------------------
  478   2018-05-30   31720e4   Cesidio Di Landa      offences-under-escorts
  476   2018-05-30   f23b882   Cesidio Di Landa      prison-dashboard
  475   2018-05-23   39511f1   Cesidio Di Landa      refactor-views
  474   2018-05-23   e722335   Andy White            add-missing-violent-description-hint
  473   2018-05-23   d8dea49   Cesidio Di Landa      refactor-presenters
  472   2018-05-22   a39c344   Andy White            add-violence-section
  471   2018-05-21   219c75a   Cesidio Di Landa      fix-search-error-messages
  468   2018-05-17   0fb8b7f   Andy White            new-search-bar
  470   2018-05-17   35986c5   Andy White            police-custody-seeds
  469   2018-05-16   6d16733   Cesidio Di Landa      fix-acct-status-text
  467   2018-05-15   d323cdd   Cesidio Di Landa      remove-schema-forms
  466   2018-05-09   3946db4   Cesidio Di Landa      simplify-risk-questions
  465   2018-05-01   c698682   Cesidio Di Landa      add_peep
  462   2018-05-01   00a3d18   Cesidio Di Landa      forbid-cancel-per-court
-->
### New
* Introduction of dedicated dashboard for police users. <!-- PR 476 -->
* New violence or dangerous risk section. <!-- PR 472 -->
* New Personal Emergency Evacuation Plan field to detainee. <!-- PR 465 -->

### Changed
* Improvements to search page. <!-- PR 471 468 -->
* Enhancements to wording of hints, question and stati. <!-- PR 474 466 469 466 -->
* Improved workflow for court users. <!-- PR 462 -->


## 2018-04-23
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------------------------
  463   2018-04-23   b4dec3e   Andy White            upd-changelog-2018-04
  461   2018-04-17   44a7f3c   Cesidio Di Landa      remove-papertrail
  458   2018-04-17   bfbaf32   Cesidio Di Landa      upgrade-rails
  457   2018-04-16   85d886a   Cesidio Di Landa      fix-leading-dot
  460   2018-04-16   76d3002   Andy White            remove-comparisons-code
  459   2018-04-16   0098d24   Andy White            form-builder-refactor
-->
### Changed
* Upgrades to internal libraries to improve security and performance. <!-- PR 458 -->
* Improvements to internal logging mechanism. <!-- PR 461 -->

### Fixed
* Fixed a bug where some labels were displaying incorrectly. <!-- PR 457 -->


## 2018-03
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------------------------
  452   2018-03-28   e81d90c   Cesidio Di Landa      fix-empty-dates
  454   2018-03-26   4732c68   Andy White            compare-auto-alerts-by-id-refactor
  453   2018-03-26   7addae4   Andy White            compare-auto-alerts-by-id
  424   2018-03-20   62f1056   Andy White            optional-hostage-taker-date
  450   2018-03-20   0174461   Andy White            compare-auto-alerts-enhanced
  449   2018-03-15   c702d59   Cesidio Di Landa      include-inactive-alerts
  448   2018-03-14   ca251fc   Andy White            detect-false-negatives
  446   2018-03-13   10f52e4   Cesidio Di Landa      compare-actual-with-automated-alerts-v2
  443   2018-03-13   e24661c   Cesidio Di Landa      fix-error-on-fetcher
  444   2018-03-13   937d4bb   Cesidio Di Landa      revert-442-automate-risk
  442   2018-03-13   d3d9671   Cesidio Di Landa      automate-risk
  432   2018-03-08   8e44e90   Andy White            compare-actual-with-automated-alerts
  435   2018-03-08   93e5eff   Cesidio Di Landa      fetch-risks
-->
### Changed
* Improved presentation of dates on ePER print. <!-- PR 452 -->
* Change hostage taker last incident dates to make them optional. <!-- PR 424 -->
* Change presentation of ePER to inactive alerts from NOMIS. <!-- PR 449 -->
* Improvements to internal reporting which is used to inform future features. <!-- PR 454 453 450 448 446 432 435 -->


## 2018-02-23
<!-- Inferred release of all PRs merged in this calendar month:
   PR   Merge date   Commit    Author                Branch
 -----------------------------------------------------------------------------------------------
  441   2018-02-23   86dd9af   Cesidio Di Landa      add-details
  440   2018-02-21   422e9e6   Cesidio Di Landa      not-for-release
  439   2018-02-15   c18d065   Cesidio Di Landa      update-rails
  438   2018-02-15   67ffd00   Cesidio Di Landa      remove-unused-code
  436   2018-02-14   16147cb   Cesidio Di Landa      update-gems
  433   2018-02-06   2599015   Cesidio Di Landa      store-changes
  434   2018-02-06   b71692d   Cesidio Di Landa      update-migrations-and-schema
  431   2018-02-01   6bf54e2   Cesidio Di Landa      central-update
-->
### Changed
- Improved Release Status text and easier editing
- Better defaults for prisoner location if NOMIS API is down
- Better wording for information on journeys
- Improved wording and usability in gangs section
- Improved display of alerts in court receiver view
- All cancelled PERs now appear together at the bottom of the list
- Improved saved time calculations in Geckoboard reporting
- Improved service monitoring information

### Added
- The Personal details sections has added fields:
  - Preferred language
  - Dietary requirements

### Fixed
- Fixed a bug which had stopped logging to Google Analytics
- Fixed a bug where long ethnicity information was spilling onto other page components
- Fixed a bug where long prisoner names were not wrapping correctly in the sidebar


## 2018-01-02
### Changed
- Improved display where a question has multiple parts to the answer to make it more understandable.
- Improved wording in _Not for release_ section.
- Header now reads _Create or view a PER_.
- Improved display and interaction in _Offences_ section.
- Improved layout of alerts

### Added
- Added the wording _No known risks_ to sections with no risks to avoid ambiguity.
- Information on Single Sign-on added to healthcare endpoint

### Fixed
- No longer lists prisons that have ended in list of prisons in destination section.


## 2017-12-13
### Added
- Added the ability to cancel a PER after it has been issued so the destination can be informed.

### Changed
- Improvements to KPI calculations to enable us to more accurately assess how much time is being saved by the system.
- Better displaying of ACCT information when it has been closed to make it clearer.
- Clearer prompts when starting a PER to reduce confusion.
- Better warnings to help identify vunerable prisoners


## 2017-11
### Added
- New prison and court user types with relevant views and dashboards to simplify the user experience.
- New user roles with specific access to admin, healthcare etc. This allows safer access for different roles of user.
- Add numbers of previous convictions to assist assessment of risk level for offenders.
- New contact us form for reporting support issues.

### Changed
- Improved _Move information_ page. The _To_ section now has separate, auto complete fields for the different categories of destination.
- Improved the way offences are presented so they are clearer.
- Expand information on risks and health section so each item is visible.
- Clean up presentation of profile page so that key information can be seen more easily.
- Date of sexual offence is now optional. This is not always known.
- Flow of questions in risk section improved to streamline the user experience.
- Better self harm questions to help keep offenders safe.
- Improved the way offender information is displayed to aid identification.

### Fixed
- Various layout tweaks to fix minor presentation anomalies.
- Fixed a bug where self harm alerts were sometimes not showing.


## 2017-09-14
### Added
- Added a floating side bar displaying detainee and move details to ePER editing screens. This ensures that detainee and move details are visible at all stages of ePER creation.


## 2017-09-06
### Added
- Added new dosage and frequency fields to the _Essential Medication_ section of the ePER to improve how essential medication is administered.

### Changed
- Changes to the way cookies are created and stored to increase security.
