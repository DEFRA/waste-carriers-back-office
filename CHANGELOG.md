# Changelog

## [Unreleased](https://github.com/defra/waste-carriers-back-office/tree/HEAD)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.9.1...HEAD)

**Implemented enhancements:**

- Update registration seeding API [\#919](https://github.com/DEFRA/waste-carriers-back-office/pull/919) ([cintamani](https://github.com/cintamani))
- Update defra-ruby-aws to AWS:KMS version [\#918](https://github.com/DEFRA/waste-carriers-back-office/pull/918) ([Cruikshanks](https://github.com/Cruikshanks))

**Fixed bugs:**

- Convert max transient reg age in days to integer [\#920](https://github.com/DEFRA/waste-carriers-back-office/pull/920) ([irisfaraway](https://github.com/irisfaraway))

## [v1.9.1](https://github.com/defra/waste-carriers-back-office/tree/v1.9.1) (2020-06-18)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.9.0...v1.9.1)

**Fixed bugs:**

- Fix cleanup:transient\_registrations rake task [\#916](https://github.com/DEFRA/waste-carriers-back-office/pull/916) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `35af4c3` to `8730699` [\#917](https://github.com/DEFRA/waste-carriers-back-office/pull/917) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.9.0](https://github.com/defra/waste-carriers-back-office/tree/v1.9.0) (2020-06-18)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.8.3...v1.9.0)

**Implemented enhancements:**

- Cleanup after removing link from completed pages [\#906](https://github.com/DEFRA/waste-carriers-back-office/pull/906) ([cintamani](https://github.com/cintamani))
- Only send reminder emails to contact addresses [\#905](https://github.com/DEFRA/waste-carriers-back-office/pull/905) ([cintamani](https://github.com/cintamani))
- Allow finance admins to add missed Worldpay payments to in-progress new registrations [\#902](https://github.com/DEFRA/waste-carriers-back-office/pull/902) ([irisfaraway](https://github.com/irisfaraway))
- Allow NCCC to send new regs back from Worldpay to payment summary [\#899](https://github.com/DEFRA/waste-carriers-back-office/pull/899) ([irisfaraway](https://github.com/irisfaraway))
- Hide resend renewal email via feature toggle [\#898](https://github.com/DEFRA/waste-carriers-back-office/pull/898) ([cintamani](https://github.com/cintamani))
- Don't display reg\_identifiers for in-progress new regs [\#895](https://github.com/DEFRA/waste-carriers-back-office/pull/895) ([irisfaraway](https://github.com/irisfaraway))
- Add 'continue as assisted digital' button to new reg view [\#894](https://github.com/DEFRA/waste-carriers-back-office/pull/894) ([irisfaraway](https://github.com/irisfaraway))
- Don't display resume link for new regs unless users have permission [\#893](https://github.com/DEFRA/waste-carriers-back-office/pull/893) ([irisfaraway](https://github.com/irisfaraway))
- Add frame-ancestors settings to CSP [\#892](https://github.com/DEFRA/waste-carriers-back-office/pull/892) ([irisfaraway](https://github.com/irisfaraway))
- Remove older transient\_registrations with no created\_at [\#891](https://github.com/DEFRA/waste-carriers-back-office/pull/891) ([irisfaraway](https://github.com/irisfaraway))
- Exclude cancelled in progress renewals from convictions checks [\#890](https://github.com/DEFRA/waste-carriers-back-office/pull/890) ([cintamani](https://github.com/cintamani))
- Switch on 'finished' button for new reg journey [\#889](https://github.com/DEFRA/waste-carriers-back-office/pull/889) ([irisfaraway](https://github.com/irisfaraway))
- Add rake task to remove old transient\_registrations [\#886](https://github.com/DEFRA/waste-carriers-back-office/pull/886) ([irisfaraway](https://github.com/irisfaraway))
- Add resume link for in progress new registrations [\#882](https://github.com/DEFRA/waste-carriers-back-office/pull/882) ([cintamani](https://github.com/cintamani))
- Fix bug in ordering mixed resources [\#880](https://github.com/DEFRA/waste-carriers-back-office/pull/880) ([cintamani](https://github.com/cintamani))
- Add link to re-send a renewal reminder email [\#879](https://github.com/DEFRA/waste-carriers-back-office/pull/879) ([cintamani](https://github.com/cintamani))
- Add view details page for new registrations [\#878](https://github.com/DEFRA/waste-carriers-back-office/pull/878) ([irisfaraway](https://github.com/irisfaraway))
- Return new registration results in dashboard search [\#876](https://github.com/DEFRA/waste-carriers-back-office/pull/876) ([cintamani](https://github.com/cintamani))
- Add surname to renewal reminder emails [\#874](https://github.com/DEFRA/waste-carriers-back-office/pull/874) ([cintamani](https://github.com/cintamani))
- Uodate back button path to new backoffice [\#873](https://github.com/DEFRA/waste-carriers-back-office/pull/873) ([cintamani](https://github.com/cintamani))
- Update text on renew via magic link email [\#869](https://github.com/DEFRA/waste-carriers-back-office/pull/869) ([cintamani](https://github.com/cintamani))
- Update permissions to view link to new registrations [\#866](https://github.com/DEFRA/waste-carriers-back-office/pull/866) ([cintamani](https://github.com/cintamani))
- Update templates of first and second renewal email reminders [\#860](https://github.com/DEFRA/waste-carriers-back-office/pull/860) ([cintamani](https://github.com/cintamani))
- Add new registration action to back office [\#858](https://github.com/DEFRA/waste-carriers-back-office/pull/858) ([cintamani](https://github.com/cintamani))
- Add cancel functionality for in-progress registrations [\#856](https://github.com/DEFRA/waste-carriers-back-office/pull/856) ([cintamani](https://github.com/cintamani))
- Fix link from renewal emails [\#847](https://github.com/DEFRA/waste-carriers-back-office/pull/847) ([cintamani](https://github.com/cintamani))
- Generate magic link when sending email reminders [\#845](https://github.com/DEFRA/waste-carriers-back-office/pull/845) ([cintamani](https://github.com/cintamani))
- Add configs for defra ruby address gem [\#832](https://github.com/DEFRA/waste-carriers-back-office/pull/832) ([cintamani](https://github.com/cintamani))
- Change seeds api to set expires\_on [\#830](https://github.com/DEFRA/waste-carriers-back-office/pull/830) ([cintamani](https://github.com/cintamani))
- Add API endpoint to seed data using JSON seeds [\#824](https://github.com/DEFRA/waste-carriers-back-office/pull/824) ([cintamani](https://github.com/cintamani))
- Schedule second email reminder [\#823](https://github.com/DEFRA/waste-carriers-back-office/pull/823) ([cintamani](https://github.com/cintamani))
- Generate second renewal reminder email [\#822](https://github.com/DEFRA/waste-carriers-back-office/pull/822) ([cintamani](https://github.com/cintamani))
- Add feature toggle to email reminders [\#820](https://github.com/DEFRA/waste-carriers-back-office/pull/820) ([cintamani](https://github.com/cintamani))
- Schedule first email reminder task [\#817](https://github.com/DEFRA/waste-carriers-back-office/pull/817) ([cintamani](https://github.com/cintamani))
- Add  code to send first renewal reminder letter via rake task [\#814](https://github.com/DEFRA/waste-carriers-back-office/pull/814) ([cintamani](https://github.com/cintamani))
- Add base service to fetch expiring registrations [\#812](https://github.com/DEFRA/waste-carriers-back-office/pull/812) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Move .cancelled scope in convictions dashboard [\#897](https://github.com/DEFRA/waste-carriers-back-office/pull/897) ([irisfaraway](https://github.com/irisfaraway))
- Restore registration type instead of business type [\#883](https://github.com/DEFRA/waste-carriers-back-office/pull/883) ([cintamani](https://github.com/cintamani))
- Update .travis.yml [\#863](https://github.com/DEFRA/waste-carriers-back-office/pull/863) ([cintamani](https://github.com/cintamani))
- Fix impossible logic in renewal\_received\_form rake task [\#854](https://github.com/DEFRA/waste-carriers-back-office/pull/854) ([irisfaraway](https://github.com/irisfaraway))
- Fix links without fixing the value shown to the user [\#850](https://github.com/DEFRA/waste-carriers-back-office/pull/850) ([cintamani](https://github.com/cintamani))
- Add one-off rake task to update defunct renewal workflow\_state [\#849](https://github.com/DEFRA/waste-carriers-back-office/pull/849) ([irisfaraway](https://github.com/irisfaraway))
- Update class name to match file [\#842](https://github.com/DEFRA/waste-carriers-back-office/pull/842) ([cintamani](https://github.com/cintamani))
- Use env variable for AD email [\#836](https://github.com/DEFRA/waste-carriers-back-office/pull/836) ([cintamani](https://github.com/cintamani))
- Fix SonarCloud code coverage reporting [\#825](https://github.com/DEFRA/waste-carriers-back-office/pull/825) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix error on configuration application [\#816](https://github.com/DEFRA/waste-carriers-back-office/pull/816) ([cintamani](https://github.com/cintamani))
- Don't try to display account email if none exists [\#815](https://github.com/DEFRA/waste-carriers-back-office/pull/815) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `cd29ed5` to `35af4c3` [\#914](https://github.com/DEFRA/waste-carriers-back-office/pull/914) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4cc7970` to `cd29ed5` [\#913](https://github.com/DEFRA/waste-carriers-back-office/pull/913) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Correct reminder email default values [\#912](https://github.com/DEFRA/waste-carriers-back-office/pull/912) ([andrewhick](https://github.com/andrewhick))
- Bump wicked\_pdf from 2.0.2 to 2.1.0 [\#911](https://github.com/DEFRA/waste-carriers-back-office/pull/911) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.2.1 to 0.2.2 [\#910](https://github.com/DEFRA/waste-carriers-back-office/pull/910) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0e4c50d` to `4cc7970` [\#909](https://github.com/DEFRA/waste-carriers-back-office/pull/909) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `77334cb` to `0e4c50d` [\#908](https://github.com/DEFRA/waste-carriers-back-office/pull/908) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4453dae` to `77334cb` [\#907](https://github.com/DEFRA/waste-carriers-back-office/pull/907) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a2696ab` to `4453dae` [\#904](https://github.com/DEFRA/waste-carriers-back-office/pull/904) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.7.1 to 4.7.2 [\#903](https://github.com/DEFRA/waste-carriers-back-office/pull/903) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_mocks from 1.4.1 to 1.5.0 [\#901](https://github.com/DEFRA/waste-carriers-back-office/pull/901) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `df8c7cc` to `a2696ab` [\#900](https://github.com/DEFRA/waste-carriers-back-office/pull/900) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_mocks from 1.4.0 to 1.4.1 [\#896](https://github.com/DEFRA/waste-carriers-back-office/pull/896) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a087526` to `1fd948b` [\#888](https://github.com/DEFRA/waste-carriers-back-office/pull/888) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6be106b` to `a087526` [\#887](https://github.com/DEFRA/waste-carriers-back-office/pull/887) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1e06ee7` to `6be106b` [\#885](https://github.com/DEFRA/waste-carriers-back-office/pull/885) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump kaminari from 1.2.0 to 1.2.1 [\#884](https://github.com/DEFRA/waste-carriers-back-office/pull/884) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `39401f1` to `1e06ee7` [\#881](https://github.com/DEFRA/waste-carriers-back-office/pull/881) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5cf6724` to `39401f1` [\#877](https://github.com/DEFRA/waste-carriers-back-office/pull/877) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_mocks from 1.3.0 to 1.4.0 [\#875](https://github.com/DEFRA/waste-carriers-back-office/pull/875) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `97f6a2b` to `5cf6724` [\#872](https://github.com/DEFRA/waste-carriers-back-office/pull/872) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bc72fea` to `97f6a2b` [\#871](https://github.com/DEFRA/waste-carriers-back-office/pull/871) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ecb2fbd` to `bc72fea` [\#870](https://github.com/DEFRA/waste-carriers-back-office/pull/870) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `00f673b` to `ecb2fbd` [\#868](https://github.com/DEFRA/waste-carriers-back-office/pull/868) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b5c3b2f` to `00f673b` [\#867](https://github.com/DEFRA/waste-carriers-back-office/pull/867) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `67c6cf5` to `b5c3b2f` [\#865](https://github.com/DEFRA/waste-carriers-back-office/pull/865) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `575748f` to `67c6cf5` [\#864](https://github.com/DEFRA/waste-carriers-back-office/pull/864) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rails from 4.2.11.1 to 4.2.11.3 [\#862](https://github.com/DEFRA/waste-carriers-back-office/pull/862) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c0ef74a` to `575748f` [\#859](https://github.com/DEFRA/waste-carriers-back-office/pull/859) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `622f031` to `c0ef74a` [\#857](https://github.com/DEFRA/waste-carriers-back-office/pull/857) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e12af05` to `622f031` [\#855](https://github.com/DEFRA/waste-carriers-back-office/pull/855) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d78ff2b` to `e12af05` [\#853](https://github.com/DEFRA/waste-carriers-back-office/pull/853) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump jquery-rails from 4.3.5 to 4.4.0 [\#852](https://github.com/DEFRA/waste-carriers-back-office/pull/852) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `810ea07` to `d78ff2b` [\#851](https://github.com/DEFRA/waste-carriers-back-office/pull/851) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d64e78f` to `810ea07` [\#848](https://github.com/DEFRA/waste-carriers-back-office/pull/848) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d68af7e` to `d64e78f` [\#846](https://github.com/DEFRA/waste-carriers-back-office/pull/846) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.8.4 to 1.8.5 [\#844](https://github.com/DEFRA/waste-carriers-back-office/pull/844) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `9dc4091` to `d68af7e` [\#843](https://github.com/DEFRA/waste-carriers-back-office/pull/843) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7fa46c8` to `9dc4091` [\#841](https://github.com/DEFRA/waste-carriers-back-office/pull/841) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6561448` to `7fa46c8` [\#840](https://github.com/DEFRA/waste-carriers-back-office/pull/840) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `08f2360` to `6561448` [\#839](https://github.com/DEFRA/waste-carriers-back-office/pull/839) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dcfd2a0` to `08f2360` [\#838](https://github.com/DEFRA/waste-carriers-back-office/pull/838) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `60f00e0` to `dcfd2a0` [\#837](https://github.com/DEFRA/waste-carriers-back-office/pull/837) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `33df27c` to `60f00e0` [\#835](https://github.com/DEFRA/waste-carriers-back-office/pull/835) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e3358fa` to `33df27c` [\#834](https://github.com/DEFRA/waste-carriers-back-office/pull/834) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dc04bd5` to `e3358fa` [\#833](https://github.com/DEFRA/waste-carriers-back-office/pull/833) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a26d99c` to `dc04bd5` [\#831](https://github.com/DEFRA/waste-carriers-back-office/pull/831) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `75330ec` to `a26d99c` [\#829](https://github.com/DEFRA/waste-carriers-back-office/pull/829) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.1.1 to 5.2.0 [\#828](https://github.com/DEFRA/waste-carriers-back-office/pull/828) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use multiple rubocop formats in Travis build [\#827](https://github.com/DEFRA/waste-carriers-back-office/pull/827) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump defra\_ruby\_style from 0.1.4 to 0.2.1 [\#826](https://github.com/DEFRA/waste-carriers-back-office/pull/826) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b6a56e6` to `75330ec` [\#821](https://github.com/DEFRA/waste-carriers-back-office/pull/821) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `336551e` to `b6a56e6` [\#819](https://github.com/DEFRA/waste-carriers-back-office/pull/819) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `46ec95b` to `336551e` [\#818](https://github.com/DEFRA/waste-carriers-back-office/pull/818) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2799dbf` to `46ec95b` [\#813](https://github.com/DEFRA/waste-carriers-back-office/pull/813) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.8.3](https://github.com/defra/waste-carriers-back-office/tree/v1.8.3) (2020-05-12)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.8.2...v1.8.3)

## [v1.8.2](https://github.com/defra/waste-carriers-back-office/tree/v1.8.2) (2020-05-12)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.8.1...v1.8.2)

## [v1.8.1](https://github.com/defra/waste-carriers-back-office/tree/v1.8.1) (2020-04-17)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.8.0...v1.8.1)

**Implemented enhancements:**

- Add expired registrations in grace window to EPR [\#811](https://github.com/DEFRA/waste-carriers-back-office/pull/811) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `d66bdf7` to `2799dbf` [\#810](https://github.com/DEFRA/waste-carriers-back-office/pull/810) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dbda1b9` to `d66bdf7` [\#809](https://github.com/DEFRA/waste-carriers-back-office/pull/809) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `18ec4fd` to `dbda1b9` [\#808](https://github.com/DEFRA/waste-carriers-back-office/pull/808) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.8.0](https://github.com/defra/waste-carriers-back-office/tree/v1.8.0) (2020-04-09)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.7.3...v1.8.0)

**Implemented enhancements:**

- Enable Edit registration feature [\#805](https://github.com/DEFRA/waste-carriers-back-office/pull/805) ([Cruikshanks](https://github.com/Cruikshanks))
- Add api endpoint for acceptance tests [\#800](https://github.com/DEFRA/waste-carriers-back-office/pull/800) ([cintamani](https://github.com/cintamani))

**Security fixes:**

- Fix json dependency security issue [\#807](https://github.com/DEFRA/waste-carriers-back-office/pull/807) ([Cruikshanks](https://github.com/Cruikshanks))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `9ccbf57` to `18ec4fd` [\#806](https://github.com/DEFRA/waste-carriers-back-office/pull/806) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c000244` to `9ccbf57` [\#804](https://github.com/DEFRA/waste-carriers-back-office/pull/804) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.15.1 to 1.15.2 [\#802](https://github.com/DEFRA/waste-carriers-back-office/pull/802) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `65ba6f3` to `c000244` [\#801](https://github.com/DEFRA/waste-carriers-back-office/pull/801) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0dc0504` to `65ba6f3` [\#799](https://github.com/DEFRA/waste-carriers-back-office/pull/799) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.8.3 to 1.8.4 [\#798](https://github.com/DEFRA/waste-carriers-back-office/pull/798) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.15.0 to 1.15.1 [\#797](https://github.com/DEFRA/waste-carriers-back-office/pull/797) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bfa5496` to `0dc0504` [\#796](https://github.com/DEFRA/waste-carriers-back-office/pull/796) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a62a236` to `bfa5496` [\#795](https://github.com/DEFRA/waste-carriers-back-office/pull/795) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dc74f7e` to `a62a236` [\#794](https://github.com/DEFRA/waste-carriers-back-office/pull/794) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `71213c5` to `dc74f7e` [\#793](https://github.com/DEFRA/waste-carriers-back-office/pull/793) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8aadd24` to `71213c5` [\#792](https://github.com/DEFRA/waste-carriers-back-office/pull/792) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fef047a` to `8aadd24` [\#791](https://github.com/DEFRA/waste-carriers-back-office/pull/791) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0a9a492` to `fef047a` [\#790](https://github.com/DEFRA/waste-carriers-back-office/pull/790) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `281a17f` to `0a9a492` [\#789](https://github.com/DEFRA/waste-carriers-back-office/pull/789) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `cb17e60` to `281a17f` [\#788](https://github.com/DEFRA/waste-carriers-back-office/pull/788) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.7.3](https://github.com/defra/waste-carriers-back-office/tree/v1.7.3) (2020-03-31)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.7.2...v1.7.3)

**Fixed bugs:**

- Fix typo on conviction rejection page [\#786](https://github.com/DEFRA/waste-carriers-back-office/pull/786) ([irisfaraway](https://github.com/irisfaraway))
- Capitalise order item descriptions properly [\#784](https://github.com/DEFRA/waste-carriers-back-office/pull/784) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `7e200c9` to `cb17e60` [\#787](https://github.com/DEFRA/waste-carriers-back-office/pull/787) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ad4e54d` to `7e200c9` [\#785](https://github.com/DEFRA/waste-carriers-back-office/pull/785) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dca7eb8` to `ad4e54d` [\#783](https://github.com/DEFRA/waste-carriers-back-office/pull/783) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e6b0b92` to `dca7eb8` [\#782](https://github.com/DEFRA/waste-carriers-back-office/pull/782) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e2fb20a` to `e6b0b92` [\#781](https://github.com/DEFRA/waste-carriers-back-office/pull/781) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1877439` to `e2fb20a` [\#780](https://github.com/DEFRA/waste-carriers-back-office/pull/780) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8505fa5` to `1877439` [\#779](https://github.com/DEFRA/waste-carriers-back-office/pull/779) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `30d01bb` to `8505fa5` [\#778](https://github.com/DEFRA/waste-carriers-back-office/pull/778) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.7.2](https://github.com/defra/waste-carriers-back-office/tree/v1.7.2) (2020-03-25)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.7.1...v1.7.2)

**Fixed bugs:**

- Align data in the table correctly [\#777](https://github.com/DEFRA/waste-carriers-back-office/pull/777) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `1cf4f51` to `30d01bb` [\#776](https://github.com/DEFRA/waste-carriers-back-office/pull/776) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4aeed84` to `1cf4f51` [\#775](https://github.com/DEFRA/waste-carriers-back-office/pull/775) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `f84ad37` to `4aeed84` [\#774](https://github.com/DEFRA/waste-carriers-back-office/pull/774) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c678b90` to `f84ad37` [\#773](https://github.com/DEFRA/waste-carriers-back-office/pull/773) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `500c796` to `c678b90` [\#772](https://github.com/DEFRA/waste-carriers-back-office/pull/772) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `33898b1` to `500c796` [\#770](https://github.com/DEFRA/waste-carriers-back-office/pull/770) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump pry-byebug from 3.8.0 to 3.9.0 [\#769](https://github.com/DEFRA/waste-carriers-back-office/pull/769) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5c854e9` to `33898b1` [\#768](https://github.com/DEFRA/waste-carriers-back-office/pull/768) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.7.1](https://github.com/defra/waste-carriers-back-office/tree/v1.7.1) (2020-03-20)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.7.0...v1.7.1)

**Implemented enhancements:**

- Add style for blue application received box [\#765](https://github.com/DEFRA/waste-carriers-back-office/pull/765) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Complete a registration if possible at write off [\#764](https://github.com/DEFRA/waste-carriers-back-office/pull/764) ([cintamani](https://github.com/cintamani))
- Use sequence to generate reg\_identifier [\#755](https://github.com/DEFRA/waste-carriers-back-office/pull/755) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `e7a6c37` to `5c854e9` [\#767](https://github.com/DEFRA/waste-carriers-back-office/pull/767) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump wicked\_pdf from 2.0.1 to 2.0.2 [\#766](https://github.com/DEFRA/waste-carriers-back-office/pull/766) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4b8b599` to `e7a6c37` [\#763](https://github.com/DEFRA/waste-carriers-back-office/pull/763) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `cc6f58b` to `4b8b599` [\#762](https://github.com/DEFRA/waste-carriers-back-office/pull/762) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `60b9291` to `cc6f58b` [\#761](https://github.com/DEFRA/waste-carriers-back-office/pull/761) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3ecb54a` to `60b9291` [\#760](https://github.com/DEFRA/waste-carriers-back-office/pull/760) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 2.2.0 to 2.3.0 [\#759](https://github.com/DEFRA/waste-carriers-back-office/pull/759) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5df038d` to `3ecb54a` [\#758](https://github.com/DEFRA/waste-carriers-back-office/pull/758) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `481c247` to `5df038d` [\#756](https://github.com/DEFRA/waste-carriers-back-office/pull/756) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ec13c0b` to `481c247` [\#753](https://github.com/DEFRA/waste-carriers-back-office/pull/753) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a7e47aa` to `ec13c0b` [\#752](https://github.com/DEFRA/waste-carriers-back-office/pull/752) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.7.0](https://github.com/defra/waste-carriers-back-office/tree/v1.7.0) (2020-03-11)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.6.0...v1.7.0)

**Implemented enhancements:**

- Use existing ENV variable for Registration charges [\#748](https://github.com/DEFRA/waste-carriers-back-office/pull/748) ([cintamani](https://github.com/cintamani))
- Add charge value for New registrations [\#747](https://github.com/DEFRA/waste-carriers-back-office/pull/747) ([cintamani](https://github.com/cintamani))
- Add validation on length for conviction reason [\#734](https://github.com/DEFRA/waste-carriers-back-office/pull/734) ([cintamani](https://github.com/cintamani))
- Add hint to all text areas [\#723](https://github.com/DEFRA/waste-carriers-back-office/pull/723) ([cintamani](https://github.com/cintamani))
- Add company info panel to payment pages [\#722](https://github.com/DEFRA/waste-carriers-back-office/pull/722) ([cintamani](https://github.com/cintamani))
- Enable defra-ruby-email in the project [\#712](https://github.com/DEFRA/waste-carriers-back-office/pull/712) ([Cruikshanks](https://github.com/Cruikshanks))
- Add validation for date in the past [\#699](https://github.com/DEFRA/waste-carriers-back-office/pull/699) ([cintamani](https://github.com/cintamani))
- Add validations in inclusion for payments and charge adjust [\#698](https://github.com/DEFRA/waste-carriers-back-office/pull/698) ([cintamani](https://github.com/cintamani))
- Restore links to finance functionality [\#697](https://github.com/DEFRA/waste-carriers-back-office/pull/697) ([cintamani](https://github.com/cintamani))
- Add validation to payments form  [\#696](https://github.com/DEFRA/waste-carriers-back-office/pull/696) ([cintamani](https://github.com/cintamani))
- Rename PaymentForm to BasePaymentForm [\#692](https://github.com/DEFRA/waste-carriers-back-office/pull/692) ([cintamani](https://github.com/cintamani))
- Add form to charge adjust in order to handle validations [\#690](https://github.com/DEFRA/waste-carriers-back-office/pull/690) ([cintamani](https://github.com/cintamani))
- Rename payment to payment form [\#683](https://github.com/DEFRA/waste-carriers-back-office/pull/683) ([cintamani](https://github.com/cintamani))
- Rename charge adjust to charge adjust form [\#681](https://github.com/DEFRA/waste-carriers-back-office/pull/681) ([cintamani](https://github.com/cintamani))
- Add view payments ability [\#666](https://github.com/DEFRA/waste-carriers-back-office/pull/666) ([cintamani](https://github.com/cintamani))
- Add styles for edit feature [\#665](https://github.com/DEFRA/waste-carriers-back-office/pull/665) ([irisfaraway](https://github.com/irisfaraway))
- Finance - Add ability to revert a payment [\#664](https://github.com/DEFRA/waste-carriers-back-office/pull/664) ([cintamani](https://github.com/cintamani))
- Update details link text [\#661](https://github.com/DEFRA/waste-carriers-back-office/pull/661) ([irisfaraway](https://github.com/irisfaraway))
- Add edit link to registration details page [\#660](https://github.com/DEFRA/waste-carriers-back-office/pull/660) ([irisfaraway](https://github.com/irisfaraway))
- Add edit ability [\#657](https://github.com/DEFRA/waste-carriers-back-office/pull/657) ([irisfaraway](https://github.com/irisfaraway))
- Log error from completion service without parsing it [\#654](https://github.com/DEFRA/waste-carriers-back-office/pull/654) ([cintamani](https://github.com/cintamani))
- Add renewing after create to write off [\#652](https://github.com/DEFRA/waste-carriers-back-office/pull/652) ([cintamani](https://github.com/cintamani))
- Display 'view certificate' actions link [\#646](https://github.com/DEFRA/waste-carriers-back-office/pull/646) ([irisfaraway](https://github.com/irisfaraway))
- Finance - Charge adjust [\#644](https://github.com/DEFRA/waste-carriers-back-office/pull/644) ([cintamani](https://github.com/cintamani))
- View registration certificate in back office [\#642](https://github.com/DEFRA/waste-carriers-back-office/pull/642) ([irisfaraway](https://github.com/irisfaraway))
- More fixes to BOXI [\#625](https://github.com/DEFRA/waste-carriers-back-office/pull/625) ([cintamani](https://github.com/cintamani))
- Fix links to new payments [\#622](https://github.com/DEFRA/waste-carriers-back-office/pull/622) ([cintamani](https://github.com/cintamani))
- Update mock engine to get Worldpay refund support [\#609](https://github.com/DEFRA/waste-carriers-back-office/pull/609) ([Cruikshanks](https://github.com/Cruikshanks))
- Update mocks engine to support Worldpay [\#604](https://github.com/DEFRA/waste-carriers-back-office/pull/604) ([Cruikshanks](https://github.com/Cruikshanks))
- Process payment on registrations [\#603](https://github.com/DEFRA/waste-carriers-back-office/pull/603) ([cintamani](https://github.com/cintamani))
- Add page to import convictions [\#601](https://github.com/DEFRA/waste-carriers-back-office/pull/601) ([irisfaraway](https://github.com/irisfaraway))
- Add resource scope [\#600](https://github.com/DEFRA/waste-carriers-back-office/pull/600) ([cintamani](https://github.com/cintamani))
- Unify refund headers [\#599](https://github.com/DEFRA/waste-carriers-back-office/pull/599) ([cintamani](https://github.com/cintamani))
- Finance - Write Offs [\#595](https://github.com/DEFRA/waste-carriers-back-office/pull/595) ([cintamani](https://github.com/cintamani))
- Set up ConvictionImportService [\#594](https://github.com/DEFRA/waste-carriers-back-office/pull/594) ([irisfaraway](https://github.com/irisfaraway))
- Add support for mocking external services [\#593](https://github.com/DEFRA/waste-carriers-back-office/pull/593) ([Cruikshanks](https://github.com/Cruikshanks))
- Add 'developer' user role [\#592](https://github.com/DEFRA/waste-carriers-back-office/pull/592) ([irisfaraway](https://github.com/irisfaraway))
- Remove links for release [\#582](https://github.com/DEFRA/waste-carriers-back-office/pull/582) ([cintamani](https://github.com/cintamani))
- Use correct worldpay information [\#578](https://github.com/DEFRA/waste-carriers-back-office/pull/578) ([cintamani](https://github.com/cintamani))
- Add 'invite new user' feature [\#574](https://github.com/DEFRA/waste-carriers-back-office/pull/574) ([irisfaraway](https://github.com/irisfaraway))
- Fix buttons vertical distance [\#571](https://github.com/DEFRA/waste-carriers-back-office/pull/571) ([cintamani](https://github.com/cintamani))
- Edit permissions for cease and revoke [\#570](https://github.com/DEFRA/waste-carriers-back-office/pull/570) ([cintamani](https://github.com/cintamani))
- Change back office user role [\#569](https://github.com/DEFRA/waste-carriers-back-office/pull/569) ([irisfaraway](https://github.com/irisfaraway))
- Update view on refund details [\#568](https://github.com/DEFRA/waste-carriers-back-office/pull/568) ([cintamani](https://github.com/cintamani))
- Reword copy cards link [\#566](https://github.com/DEFRA/waste-carriers-back-office/pull/566) ([cintamani](https://github.com/cintamani))
- Hide refund button unless overpayment [\#565](https://github.com/DEFRA/waste-carriers-back-office/pull/565) ([cintamani](https://github.com/cintamani))
- Fix code to render error flash messages [\#563](https://github.com/DEFRA/waste-carriers-back-office/pull/563) ([cintamani](https://github.com/cintamani))
- Reword flash error message for worldpay refunds [\#562](https://github.com/DEFRA/waste-carriers-back-office/pull/562) ([cintamani](https://github.com/cintamani))
- Calculate the correct amount for refund [\#561](https://github.com/DEFRA/waste-carriers-back-office/pull/561) ([cintamani](https://github.com/cintamani))
- Add permissions checks to refund [\#559](https://github.com/DEFRA/waste-carriers-back-office/pull/559) ([cintamani](https://github.com/cintamani))
- Add refund request to worldpay [\#558](https://github.com/DEFRA/waste-carriers-back-office/pull/558) ([cintamani](https://github.com/cintamani))
- Refunds - Implement service [\#554](https://github.com/DEFRA/waste-carriers-back-office/pull/554) ([cintamani](https://github.com/cintamani))
- Refund Payment - Controller and index page [\#553](https://github.com/DEFRA/waste-carriers-back-office/pull/553) ([cintamani](https://github.com/cintamani))
- Add missing translations of payment types [\#551](https://github.com/DEFRA/waste-carriers-back-office/pull/551) ([cintamani](https://github.com/cintamani))
- Isolate finance details resource [\#550](https://github.com/DEFRA/waste-carriers-back-office/pull/550) ([cintamani](https://github.com/cintamani))
- Add and fix links to finance details pages [\#549](https://github.com/DEFRA/waste-carriers-back-office/pull/549) ([cintamani](https://github.com/cintamani))
- Add payment details view for transient registrations [\#548](https://github.com/DEFRA/waste-carriers-back-office/pull/548) ([cintamani](https://github.com/cintamani))
- Add view details for registrations payments [\#547](https://github.com/DEFRA/waste-carriers-back-office/pull/547) ([cintamani](https://github.com/cintamani))
- Rename payments controller to transient\_payments [\#545](https://github.com/DEFRA/waste-carriers-back-office/pull/545) ([cintamani](https://github.com/cintamani))
- Add flash messages and style for ceased or revoked [\#543](https://github.com/DEFRA/waste-carriers-back-office/pull/543) ([cintamani](https://github.com/cintamani))
- Add cease or revoke links [\#540](https://github.com/DEFRA/waste-carriers-back-office/pull/540) ([cintamani](https://github.com/cintamani))
- Add expire registrations job [\#536](https://github.com/DEFRA/waste-carriers-back-office/pull/536) ([cintamani](https://github.com/cintamani))
- Implement code for sign\_offs csv Boxi file [\#532](https://github.com/DEFRA/waste-carriers-back-office/pull/532) ([cintamani](https://github.com/cintamani))
- Implement generation of registration csv for Boxi [\#531](https://github.com/DEFRA/waste-carriers-back-office/pull/531) ([cintamani](https://github.com/cintamani))
- Add code to generate payments boxi export [\#530](https://github.com/DEFRA/waste-carriers-back-office/pull/530) ([cintamani](https://github.com/cintamani))
- Implement Boxi Orders csv file creation [\#529](https://github.com/DEFRA/waste-carriers-back-office/pull/529) ([cintamani](https://github.com/cintamani))
- Implement creation of order\_items file for Boxi [\#528](https://github.com/DEFRA/waste-carriers-back-office/pull/528) ([cintamani](https://github.com/cintamani))
- Add key people file creation on Boxi export [\#527](https://github.com/DEFRA/waste-carriers-back-office/pull/527) ([cintamani](https://github.com/cintamani))
- Add base boxi report generator service [\#525](https://github.com/DEFRA/waste-carriers-back-office/pull/525) ([cintamani](https://github.com/cintamani))
- Naming fixes to exports code structure [\#522](https://github.com/DEFRA/waste-carriers-back-office/pull/522) ([cintamani](https://github.com/cintamani))
- Add main service for boxi export job [\#521](https://github.com/DEFRA/waste-carriers-back-office/pull/521) ([cintamani](https://github.com/cintamani))
- Implement EPR export [\#519](https://github.com/DEFRA/waste-carriers-back-office/pull/519) ([cintamani](https://github.com/cintamani))
- Activate and deactivate back office users [\#514](https://github.com/DEFRA/waste-carriers-back-office/pull/514) ([irisfaraway](https://github.com/irisfaraway))
- Update user list [\#513](https://github.com/DEFRA/waste-carriers-back-office/pull/513) ([irisfaraway](https://github.com/irisfaraway))
- Add formatted date for order copy cards mailer [\#509](https://github.com/DEFRA/waste-carriers-back-office/pull/509) ([cintamani](https://github.com/cintamani))
- Remove unused code [\#506](https://github.com/DEFRA/waste-carriers-back-office/pull/506) ([cintamani](https://github.com/cintamani))
- Add link to order copy cards journey [\#505](https://github.com/DEFRA/waste-carriers-back-office/pull/505) ([cintamani](https://github.com/cintamani))
- Flash messages style [\#504](https://github.com/DEFRA/waste-carriers-back-office/pull/504) ([cintamani](https://github.com/cintamani))

**Fixed bugs:**

- Fix conviction approval access permissions [\#746](https://github.com/DEFRA/waste-carriers-back-office/pull/746) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix redirect path to summary-page [\#732](https://github.com/DEFRA/waste-carriers-back-office/pull/732) ([cintamani](https://github.com/cintamani))
- Fix url to worldpay missed payment form [\#731](https://github.com/DEFRA/waste-carriers-back-office/pull/731) ([cintamani](https://github.com/cintamani))
- Fix Transfer registration page rendering [\#730](https://github.com/DEFRA/waste-carriers-back-office/pull/730) ([Cruikshanks](https://github.com/Cruikshanks))
- Clarify payment details access [\#726](https://github.com/DEFRA/waste-carriers-back-office/pull/726) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove ability to access finance details on unsubmitted renewals [\#717](https://github.com/DEFRA/waste-carriers-back-office/pull/717) ([cintamani](https://github.com/cintamani))
- Update translations for negative charge adjust [\#710](https://github.com/DEFRA/waste-carriers-back-office/pull/710) ([cintamani](https://github.com/cintamani))
- Fix back path for finance details page [\#706](https://github.com/DEFRA/waste-carriers-back-office/pull/706) ([cintamani](https://github.com/cintamani))
- Remove double validation on amounts [\#705](https://github.com/DEFRA/waste-carriers-back-office/pull/705) ([cintamani](https://github.com/cintamani))
- Fix renewal bug on charge adjust [\#702](https://github.com/DEFRA/waste-carriers-back-office/pull/702) ([cintamani](https://github.com/cintamani))
- Fix charge adjustment flash messages [\#701](https://github.com/DEFRA/waste-carriers-back-office/pull/701) ([Cruikshanks](https://github.com/Cruikshanks))
- Validate amounts to be greater than 1 cent [\#695](https://github.com/DEFRA/waste-carriers-back-office/pull/695) ([cintamani](https://github.com/cintamani))
- Remove `renewal` from payment pages [\#694](https://github.com/DEFRA/waste-carriers-back-office/pull/694) ([cintamani](https://github.com/cintamani))
- Fix validation on amounts [\#689](https://github.com/DEFRA/waste-carriers-back-office/pull/689) ([cintamani](https://github.com/cintamani))
- Fix parsing of amounts to flash message [\#688](https://github.com/DEFRA/waste-carriers-back-office/pull/688) ([cintamani](https://github.com/cintamani))
- Add ability to complete a registration after payment [\#680](https://github.com/DEFRA/waste-carriers-back-office/pull/680) ([cintamani](https://github.com/cintamani))
- Fix missing text on registration page [\#677](https://github.com/DEFRA/waste-carriers-back-office/pull/677) ([irisfaraway](https://github.com/irisfaraway))
- Payments - Move validation box above H1 [\#676](https://github.com/DEFRA/waste-carriers-back-office/pull/676) ([cintamani](https://github.com/cintamani))
- Fix bug on worlpday missed payment for registrations [\#674](https://github.com/DEFRA/waste-carriers-back-office/pull/674) ([cintamani](https://github.com/cintamani))
- Fix back buttons [\#672](https://github.com/DEFRA/waste-carriers-back-office/pull/672) ([cintamani](https://github.com/cintamani))
- Redirect to correct resource page after renewal is completed [\#670](https://github.com/DEFRA/waste-carriers-back-office/pull/670) ([cintamani](https://github.com/cintamani))
- Fix id of fieldset for validation link [\#668](https://github.com/DEFRA/waste-carriers-back-office/pull/668) ([cintamani](https://github.com/cintamani))
- Remove expired panel from renewing registration details page [\#662](https://github.com/DEFRA/waste-carriers-back-office/pull/662) ([cintamani](https://github.com/cintamani))
- Move title and validations to two-thirds column [\#655](https://github.com/DEFRA/waste-carriers-back-office/pull/655) ([cintamani](https://github.com/cintamani))
- Fix finance role permissions [\#653](https://github.com/DEFRA/waste-carriers-back-office/pull/653) ([irisfaraway](https://github.com/irisfaraway))
- Write offs - fixes [\#645](https://github.com/DEFRA/waste-carriers-back-office/pull/645) ([cintamani](https://github.com/cintamani))
- Fix sanitizer method [\#641](https://github.com/DEFRA/waste-carriers-back-office/pull/641) ([cintamani](https://github.com/cintamani))
- Boxi - Unique UID for orders [\#640](https://github.com/DEFRA/waste-carriers-back-office/pull/640) ([cintamani](https://github.com/cintamani))
- Fix parsing carriage returns in BOXI export [\#634](https://github.com/DEFRA/waste-carriers-back-office/pull/634) ([Cruikshanks](https://github.com/Cruikshanks))
- Actually fix redirect after accepting user invite [\#630](https://github.com/DEFRA/waste-carriers-back-office/pull/630) ([irisfaraway](https://github.com/irisfaraway))
- Remove change to wrong presenter [\#626](https://github.com/DEFRA/waste-carriers-back-office/pull/626) ([cintamani](https://github.com/cintamani))
- Fix broken 'Finished' link on renewal end pages [\#619](https://github.com/DEFRA/waste-carriers-back-office/pull/619) ([irisfaraway](https://github.com/irisfaraway))
- Redirect to BO dashboard after creating new account [\#617](https://github.com/DEFRA/waste-carriers-back-office/pull/617) ([irisfaraway](https://github.com/irisfaraway))
- ConvictionImportService validates DOB if provided [\#616](https://github.com/DEFRA/waste-carriers-back-office/pull/616) ([irisfaraway](https://github.com/irisfaraway))
- Add guard clause to missing object [\#614](https://github.com/DEFRA/waste-carriers-back-office/pull/614) ([cintamani](https://github.com/cintamani))
- Fix format of amounts in boxi export [\#613](https://github.com/DEFRA/waste-carriers-back-office/pull/613) ([cintamani](https://github.com/cintamani))
- Set a worldpay response type [\#612](https://github.com/DEFRA/waste-carriers-back-office/pull/612) ([cintamani](https://github.com/cintamani))
- Fix dates in boxi export [\#611](https://github.com/DEFRA/waste-carriers-back-office/pull/611) ([cintamani](https://github.com/cintamani))
- Fix typo in boxi default filename [\#606](https://github.com/DEFRA/waste-carriers-back-office/pull/606) ([cintamani](https://github.com/cintamani))
- Fix bug in BOXI export [\#605](https://github.com/DEFRA/waste-carriers-back-office/pull/605) ([cintamani](https://github.com/cintamani))
- Fixes to refunds [\#598](https://github.com/DEFRA/waste-carriers-back-office/pull/598) ([cintamani](https://github.com/cintamani))
- Fix flash messages colours [\#596](https://github.com/DEFRA/waste-carriers-back-office/pull/596) ([cintamani](https://github.com/cintamani))
- Fix wonky validation on user invite form [\#591](https://github.com/DEFRA/waste-carriers-back-office/pull/591) ([irisfaraway](https://github.com/irisfaraway))
- Fix default email protocol [\#590](https://github.com/DEFRA/waste-carriers-back-office/pull/590) ([irisfaraway](https://github.com/irisfaraway))
- Add missing titles to new user invite pages [\#588](https://github.com/DEFRA/waste-carriers-back-office/pull/588) ([irisfaraway](https://github.com/irisfaraway))
- Add process payment button to action list [\#586](https://github.com/DEFRA/waste-carriers-back-office/pull/586) ([cintamani](https://github.com/cintamani))
- Fixes to refund functionality [\#585](https://github.com/DEFRA/waste-carriers-back-office/pull/585) ([cintamani](https://github.com/cintamani))
- Fix thead and tbody on refunds table [\#584](https://github.com/DEFRA/waste-carriers-back-office/pull/584) ([cintamani](https://github.com/cintamani))
- Fix thead and tbody [\#583](https://github.com/DEFRA/waste-carriers-back-office/pull/583) ([cintamani](https://github.com/cintamani))
- Add missing page titles [\#579](https://github.com/DEFRA/waste-carriers-back-office/pull/579) ([cintamani](https://github.com/cintamani))
- Add new method for finance\_details check [\#576](https://github.com/DEFRA/waste-carriers-back-office/pull/576) ([cintamani](https://github.com/cintamani))
- Add sign-out link to the deactivated page [\#573](https://github.com/DEFRA/waste-carriers-back-office/pull/573) ([irisfaraway](https://github.com/irisfaraway))
- Update finance details path [\#556](https://github.com/DEFRA/waste-carriers-back-office/pull/556) ([cintamani](https://github.com/cintamani))
- Fix bug on finance details heading lower tier old reg [\#538](https://github.com/DEFRA/waste-carriers-back-office/pull/538) ([cintamani](https://github.com/cintamani))
- Fix issue when missing finance details [\#537](https://github.com/DEFRA/waste-carriers-back-office/pull/537) ([cintamani](https://github.com/cintamani))
- Use correct bucket name for boxi [\#524](https://github.com/DEFRA/waste-carriers-back-office/pull/524) ([cintamani](https://github.com/cintamani))
- Fix flash messages colours [\#516](https://github.com/DEFRA/waste-carriers-back-office/pull/516) ([cintamani](https://github.com/cintamani))
- Fix broken back link on successful reg transfer [\#512](https://github.com/DEFRA/waste-carriers-back-office/pull/512) ([irisfaraway](https://github.com/irisfaraway))
- Fix 'continue as AD' button [\#510](https://github.com/DEFRA/waste-carriers-back-office/pull/510) ([irisfaraway](https://github.com/irisfaraway))

**Security fixes:**

- \[Security\] Bump secure\_headers from 5.1.0 to 5.2.0 [\#615](https://github.com/DEFRA/waste-carriers-back-office/pull/615) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump rack from 1.6.11 to 1.6.12 [\#523](https://github.com/DEFRA/waste-carriers-back-office/pull/523) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `015c31e` to `a7e47aa` [\#751](https://github.com/DEFRA/waste-carriers-back-office/pull/751) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.2 to 3.8.3 [\#750](https://github.com/DEFRA/waste-carriers-back-office/pull/750) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rspec-rails from 3.9.0 to 3.9.1 [\#749](https://github.com/DEFRA/waste-carriers-back-office/pull/749) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Hide start new registration behind feature toggle [\#745](https://github.com/DEFRA/waste-carriers-back-office/pull/745) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `1e75fce` to `49d4d99` [\#744](https://github.com/DEFRA/waste-carriers-back-office/pull/744) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Switch to SonarCloud from CodeClimate [\#739](https://github.com/DEFRA/waste-carriers-back-office/pull/739) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `54d420c` to `1e75fce` [\#738](https://github.com/DEFRA/waste-carriers-back-office/pull/738) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2218a55` to `54d420c` [\#737](https://github.com/DEFRA/waste-carriers-back-office/pull/737) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `589a321` to `2218a55` [\#736](https://github.com/DEFRA/waste-carriers-back-office/pull/736) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5b33d86` to `589a321` [\#735](https://github.com/DEFRA/waste-carriers-back-office/pull/735) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b933eda` to `5b33d86` [\#733](https://github.com/DEFRA/waste-carriers-back-office/pull/733) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove Transfer link from dashboard page [\#729](https://github.com/DEFRA/waste-carriers-back-office/pull/729) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove Cease & revoke link from dashboard [\#728](https://github.com/DEFRA/waste-carriers-back-office/pull/728) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `765471c` to `b933eda` [\#727](https://github.com/DEFRA/waste-carriers-back-office/pull/727) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6603a37` to `765471c` [\#725](https://github.com/DEFRA/waste-carriers-back-office/pull/725) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Hide edit functionality behind a feature toggle [\#724](https://github.com/DEFRA/waste-carriers-back-office/pull/724) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `e23969f` to `6603a37` [\#721](https://github.com/DEFRA/waste-carriers-back-office/pull/721) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `12d28b2` to `e23969f` [\#720](https://github.com/DEFRA/waste-carriers-back-office/pull/720) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c083048` to `12d28b2` [\#719](https://github.com/DEFRA/waste-carriers-back-office/pull/719) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8d8942d` to `c083048` [\#718](https://github.com/DEFRA/waste-carriers-back-office/pull/718) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `281bd88` to `8d8942d` [\#716](https://github.com/DEFRA/waste-carriers-back-office/pull/716) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump wicked\_pdf from 1.4.0 to 2.0.1 [\#714](https://github.com/DEFRA/waste-carriers-back-office/pull/714) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `edf5a11` to `281bd88` [\#713](https://github.com/DEFRA/waste-carriers-back-office/pull/713) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix typo on charge adjust validation messages [\#711](https://github.com/DEFRA/waste-carriers-back-office/pull/711) ([andrewhick](https://github.com/andrewhick))
- Remove and fix fieldsets with missing legends [\#709](https://github.com/DEFRA/waste-carriers-back-office/pull/709) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `fa3d16b` to `d28ea67` [\#708](https://github.com/DEFRA/waste-carriers-back-office/pull/708) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Make link to enter a payment consistent and clean [\#707](https://github.com/DEFRA/waste-carriers-back-office/pull/707) ([cintamani](https://github.com/cintamani))
- Bump database\_cleaner from 1.8.2 to 1.8.3 [\#704](https://github.com/DEFRA/waste-carriers-back-office/pull/704) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1215c9f` to `fa3d16b` [\#703](https://github.com/DEFRA/waste-carriers-back-office/pull/703) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add flash messages for payment taken [\#687](https://github.com/DEFRA/waste-carriers-back-office/pull/687) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `626822e` to `1215c9f` [\#686](https://github.com/DEFRA/waste-carriers-back-office/pull/686) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use HTML5 number fields for amounts and dates [\#682](https://github.com/DEFRA/waste-carriers-back-office/pull/682) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `70c7efa` to `626822e` [\#679](https://github.com/DEFRA/waste-carriers-back-office/pull/679) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a3d956d` to `70c7efa` [\#678](https://github.com/DEFRA/waste-carriers-back-office/pull/678) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c820f26` to `a3d956d` [\#675](https://github.com/DEFRA/waste-carriers-back-office/pull/675) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.1 to 3.8.2 [\#673](https://github.com/DEFRA/waste-carriers-back-office/pull/673) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b67d258` to `c820f26` [\#671](https://github.com/DEFRA/waste-carriers-back-office/pull/671) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e39f56f` to `b67d258` [\#667](https://github.com/DEFRA/waste-carriers-back-office/pull/667) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7ed46ab` to `e39f56f` [\#663](https://github.com/DEFRA/waste-carriers-back-office/pull/663) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `11f914b` to `7ed46ab` [\#659](https://github.com/DEFRA/waste-carriers-back-office/pull/659) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7c2cb01` to `11f914b` [\#658](https://github.com/DEFRA/waste-carriers-back-office/pull/658) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Clean up action link helpers [\#656](https://github.com/DEFRA/waste-carriers-back-office/pull/656) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `cbc99d5` to `af38658` [\#651](https://github.com/DEFRA/waste-carriers-back-office/pull/651) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.8.0 to 3.8.1 [\#650](https://github.com/DEFRA/waste-carriers-back-office/pull/650) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove unused passenger rake tasks [\#649](https://github.com/DEFRA/waste-carriers-back-office/pull/649) ([Cruikshanks](https://github.com/Cruikshanks))
- Delete one off address fix rake task [\#648](https://github.com/DEFRA/waste-carriers-back-office/pull/648) ([Cruikshanks](https://github.com/Cruikshanks))
- Switch airbrake mgmt to defra-ruby-alert [\#647](https://github.com/DEFRA/waste-carriers-back-office/pull/647) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `c96208c` to `cbc99d5` [\#643](https://github.com/DEFRA/waste-carriers-back-office/pull/643) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `f83ad0b` to `c96208c` [\#639](https://github.com/DEFRA/waste-carriers-back-office/pull/639) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump database\_cleaner from 1.7.0 to 1.8.2 [\#638](https://github.com/DEFRA/waste-carriers-back-office/pull/638) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 2.1.0 to 2.2.0 [\#637](https://github.com/DEFRA/waste-carriers-back-office/pull/637) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_mocks from 1.2.0 to 1.3.0 [\#636](https://github.com/DEFRA/waste-carriers-back-office/pull/636) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c371783` to `f83ad0b` [\#635](https://github.com/DEFRA/waste-carriers-back-office/pull/635) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c8a0be9` to `c371783` [\#633](https://github.com/DEFRA/waste-carriers-back-office/pull/633) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump kaminari from 1.1.1 to 1.2.0 [\#631](https://github.com/DEFRA/waste-carriers-back-office/pull/631) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.3 to 0.1.4 [\#629](https://github.com/DEFRA/waste-carriers-back-office/pull/629) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix changelog generator [\#628](https://github.com/DEFRA/waste-carriers-back-office/pull/628) ([Cruikshanks](https://github.com/Cruikshanks))
- Temp. fix for cc-test-reporter & SimpleCov 0.18 [\#627](https://github.com/DEFRA/waste-carriers-back-office/pull/627) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `22da686` to `c8a0be9` [\#623](https://github.com/DEFRA/waste-carriers-back-office/pull/623) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubyzip from 2.0.0 to 2.1.0 [\#621](https://github.com/DEFRA/waste-carriers-back-office/pull/621) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump pry-byebug from 3.7.0 to 3.8.0 [\#620](https://github.com/DEFRA/waste-carriers-back-office/pull/620) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `66748c8` to `a7ba0e7` [\#618](https://github.com/DEFRA/waste-carriers-back-office/pull/618) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b0dd26b` to `66748c8` [\#608](https://github.com/DEFRA/waste-carriers-back-office/pull/608) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump secure\_headers from 5.0.5 to 5.1.0 [\#607](https://github.com/DEFRA/waste-carriers-back-office/pull/607) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_mocks from 1.0.0 to 1.1.0 [\#602](https://github.com/DEFRA/waste-carriers-back-office/pull/602) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `613aa83` to `b0dd26b` [\#597](https://github.com/DEFRA/waste-carriers-back-office/pull/597) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `db3c645` to `613aa83` [\#589](https://github.com/DEFRA/waste-carriers-back-office/pull/589) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump webmock from 3.7.6 to 3.8.0 [\#587](https://github.com/DEFRA/waste-carriers-back-office/pull/587) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `51e3a1a` to `db3c645` [\#581](https://github.com/DEFRA/waste-carriers-back-office/pull/581) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b337d82` to `51e3a1a` [\#580](https://github.com/DEFRA/waste-carriers-back-office/pull/580) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Housekeeping ceased and removed links helpers [\#577](https://github.com/DEFRA/waste-carriers-back-office/pull/577) ([cintamani](https://github.com/cintamani))
- Add user.deactivated? method [\#575](https://github.com/DEFRA/waste-carriers-back-office/pull/575) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `aeee1c0` to `b337d82` [\#567](https://github.com/DEFRA/waste-carriers-back-office/pull/567) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e0fc16c` to `aeee1c0` [\#564](https://github.com/DEFRA/waste-carriers-back-office/pull/564) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bb33e65` to `e0fc16c` [\#560](https://github.com/DEFRA/waste-carriers-back-office/pull/560) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `208e55f` to `bb33e65` [\#557](https://github.com/DEFRA/waste-carriers-back-office/pull/557) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c4bc02e` to `208e55f` [\#555](https://github.com/DEFRA/waste-carriers-back-office/pull/555) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b866be7` to `c4bc02e` [\#552](https://github.com/DEFRA/waste-carriers-back-office/pull/552) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7edd40b` to `b866be7` [\#546](https://github.com/DEFRA/waste-carriers-back-office/pull/546) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `83c98af` to `7edd40b` [\#544](https://github.com/DEFRA/waste-carriers-back-office/pull/544) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2492876` to `83c98af` [\#542](https://github.com/DEFRA/waste-carriers-back-office/pull/542) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6a75fe8` to `2492876` [\#541](https://github.com/DEFRA/waste-carriers-back-office/pull/541) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e6b23bc` to `6a75fe8` [\#539](https://github.com/DEFRA/waste-carriers-back-office/pull/539) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fe83b05` to `e6b23bc` [\#535](https://github.com/DEFRA/waste-carriers-back-office/pull/535) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add scheduled job for boxi export [\#534](https://github.com/DEFRA/waste-carriers-back-office/pull/534) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `ca89e49` to `fe83b05` [\#533](https://github.com/DEFRA/waste-carriers-back-office/pull/533) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5a3f49e` to `ca89e49` [\#526](https://github.com/DEFRA/waste-carriers-back-office/pull/526) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0f19867` to `5a3f49e` [\#520](https://github.com/DEFRA/waste-carriers-back-office/pull/520) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c4431eb` to `0f19867` [\#518](https://github.com/DEFRA/waste-carriers-back-office/pull/518) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0a8b196` to `c4431eb` [\#517](https://github.com/DEFRA/waste-carriers-back-office/pull/517) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `10dee6f` to `0a8b196` [\#515](https://github.com/DEFRA/waste-carriers-back-office/pull/515) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2d3f099` to `10dee6f` [\#511](https://github.com/DEFRA/waste-carriers-back-office/pull/511) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1c270a9` to `2d3f099` [\#508](https://github.com/DEFRA/waste-carriers-back-office/pull/508) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `917e261` to `1f11edf` [\#502](https://github.com/DEFRA/waste-carriers-back-office/pull/502) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.6.0](https://github.com/defra/waste-carriers-back-office/tree/v1.6.0) (2019-12-11)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.5.1...v1.6.0)

**Implemented enhancements:**

- Redirects after a renewing is confirmed [\#476](https://github.com/DEFRA/waste-carriers-back-office/pull/476) ([cintamani](https://github.com/cintamani))
- Fix messages to match wireframe [\#475](https://github.com/DEFRA/waste-carriers-back-office/pull/475) ([cintamani](https://github.com/cintamani))
- Changes to finance details [\#474](https://github.com/DEFRA/waste-carriers-back-office/pull/474) ([cintamani](https://github.com/cintamani))
- Details page - Fixes [\#469](https://github.com/DEFRA/waste-carriers-back-office/pull/469) ([cintamani](https://github.com/cintamani))
- Add expired panel to view details pages [\#463](https://github.com/DEFRA/waste-carriers-back-office/pull/463) ([irisfaraway](https://github.com/irisfaraway))
- Add all action links to details page [\#462](https://github.com/DEFRA/waste-carriers-back-office/pull/462) ([cintamani](https://github.com/cintamani))
- Add renew link to actions panel in details page [\#458](https://github.com/DEFRA/waste-carriers-back-office/pull/458) ([cintamani](https://github.com/cintamani))
- Add continue application link to details page [\#457](https://github.com/DEFRA/waste-carriers-back-office/pull/457) ([cintamani](https://github.com/cintamani))
- Finance message on lower tier registration finance section [\#456](https://github.com/DEFRA/waste-carriers-back-office/pull/456) ([cintamani](https://github.com/cintamani))
- Convictions message for lower tier registrations [\#455](https://github.com/DEFRA/waste-carriers-back-office/pull/455) ([cintamani](https://github.com/cintamani))
- Remove expire information for Lower tier [\#449](https://github.com/DEFRA/waste-carriers-back-office/pull/449) ([cintamani](https://github.com/cintamani))
- Remove conviction links [\#448](https://github.com/DEFRA/waste-carriers-back-office/pull/448) ([cintamani](https://github.com/cintamani))
- Add Unknown status to conviction cheks view details [\#447](https://github.com/DEFRA/waste-carriers-back-office/pull/447) ([cintamani](https://github.com/cintamani))
- Add registration details page [\#445](https://github.com/DEFRA/waste-carriers-back-office/pull/445) ([cintamani](https://github.com/cintamani))
- Details page: TransientRegistration to RenewingRegistration [\#444](https://github.com/DEFRA/waste-carriers-back-office/pull/444) ([cintamani](https://github.com/cintamani))
- Use RenewingRegistration instead of TransientRegistration [\#432](https://github.com/DEFRA/waste-carriers-back-office/pull/432) ([cintamani](https://github.com/cintamani))
- Remove conviction details link in dashboard [\#431](https://github.com/DEFRA/waste-carriers-back-office/pull/431) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove registration information section [\#426](https://github.com/DEFRA/waste-carriers-back-office/pull/426) ([cintamani](https://github.com/cintamani))
- Accessibility - Use th in tables [\#424](https://github.com/DEFRA/waste-carriers-back-office/pull/424) ([cintamani](https://github.com/cintamani))
- Add p tag around finance details link [\#423](https://github.com/DEFRA/waste-carriers-back-office/pull/423) ([cintamani](https://github.com/cintamani))
- Fix indentation, unclosed div and link text [\#422](https://github.com/DEFRA/waste-carriers-back-office/pull/422) ([cintamani](https://github.com/cintamani))
- Show correct messag when finance information is missing [\#421](https://github.com/DEFRA/waste-carriers-back-office/pull/421) ([cintamani](https://github.com/cintamani))
- Move link down in conviction section [\#420](https://github.com/DEFRA/waste-carriers-back-office/pull/420) ([cintamani](https://github.com/cintamani))
- Match details top page with wireframes [\#419](https://github.com/DEFRA/waste-carriers-back-office/pull/419) ([cintamani](https://github.com/cintamani))
- Remove convictions link from details page actions [\#418](https://github.com/DEFRA/waste-carriers-back-office/pull/418) ([cintamani](https://github.com/cintamani))
- Update finance info section to reflect latest wireframe changes [\#413](https://github.com/DEFRA/waste-carriers-back-office/pull/413) ([cintamani](https://github.com/cintamani))
- Add actions box on Registration details page [\#412](https://github.com/DEFRA/waste-carriers-back-office/pull/412) ([cintamani](https://github.com/cintamani))
- Update conviction section in view details [\#411](https://github.com/DEFRA/waste-carriers-back-office/pull/411) ([cintamani](https://github.com/cintamani))
- Add Contact and Business details side to side panels [\#409](https://github.com/DEFRA/waste-carriers-back-office/pull/409) ([cintamani](https://github.com/cintamani))
- Update title of registration view [\#408](https://github.com/DEFRA/waste-carriers-back-office/pull/408) ([cintamani](https://github.com/cintamani))
- Add call out box for registration info [\#407](https://github.com/DEFRA/waste-carriers-back-office/pull/407) ([cintamani](https://github.com/cintamani))
- Display payment tag for new registrations [\#405](https://github.com/DEFRA/waste-carriers-back-office/pull/405) ([irisfaraway](https://github.com/irisfaraway))
- Apply role permissions to dashboard links [\#404](https://github.com/DEFRA/waste-carriers-back-office/pull/404) ([irisfaraway](https://github.com/irisfaraway))
- Add payment link for new registrations [\#402](https://github.com/DEFRA/waste-carriers-back-office/pull/402) ([irisfaraway](https://github.com/irisfaraway))
- Add conviction check link for new registrations [\#401](https://github.com/DEFRA/waste-carriers-back-office/pull/401) ([irisfaraway](https://github.com/irisfaraway))
- Display convictions tag for new registrations [\#399](https://github.com/DEFRA/waste-carriers-back-office/pull/399) ([irisfaraway](https://github.com/irisfaraway))
- Display 'new registration' for pending new regs [\#394](https://github.com/DEFRA/waste-carriers-back-office/pull/394) ([irisfaraway](https://github.com/irisfaraway))
- Display 'renew' action on renewable reg results [\#393](https://github.com/DEFRA/waste-carriers-back-office/pull/393) ([irisfaraway](https://github.com/irisfaraway))
- Display correct date on search results [\#387](https://github.com/DEFRA/waste-carriers-back-office/pull/387) ([irisfaraway](https://github.com/irisfaraway))
- Display 'transfer' link on registration results [\#386](https://github.com/DEFRA/waste-carriers-back-office/pull/386) ([irisfaraway](https://github.com/irisfaraway))
- Determine which tags to display in search results [\#384](https://github.com/DEFRA/waste-carriers-back-office/pull/384) ([irisfaraway](https://github.com/irisfaraway))
- Include registrations in dashboard search [\#382](https://github.com/DEFRA/waste-carriers-back-office/pull/382) ([irisfaraway](https://github.com/irisfaraway))
- Add visually hidden link text to search result actions [\#381](https://github.com/DEFRA/waste-carriers-back-office/pull/381) ([irisfaraway](https://github.com/irisfaraway))
- Update dashboard search result design [\#378](https://github.com/DEFRA/waste-carriers-back-office/pull/378) ([irisfaraway](https://github.com/irisfaraway))
- Add actions panel to dashboard [\#377](https://github.com/DEFRA/waste-carriers-back-office/pull/377) ([irisfaraway](https://github.com/irisfaraway))
- Update dashboard search design [\#376](https://github.com/DEFRA/waste-carriers-back-office/pull/376) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Remove all links to old backend [\#478](https://github.com/DEFRA/waste-carriers-back-office/pull/478) ([cintamani](https://github.com/cintamani))
- Fix backend links [\#473](https://github.com/DEFRA/waste-carriers-back-office/pull/473) ([irisfaraway](https://github.com/irisfaraway))
- Make 'revert to payment summary' button display [\#470](https://github.com/DEFRA/waste-carriers-back-office/pull/470) ([irisfaraway](https://github.com/irisfaraway))
- Display 'expired' instead of 'expires' if expired [\#459](https://github.com/DEFRA/waste-carriers-back-office/pull/459) ([irisfaraway](https://github.com/irisfaraway))
- Fix: xsmall -\> small [\#452](https://github.com/DEFRA/waste-carriers-back-office/pull/452) ([cintamani](https://github.com/cintamani))
- Fix typo and add missing translation [\#428](https://github.com/DEFRA/waste-carriers-back-office/pull/428) ([cintamani](https://github.com/cintamani))
- Return empty string if no date available [\#425](https://github.com/DEFRA/waste-carriers-back-office/pull/425) ([cintamani](https://github.com/cintamani))
- Add prefix to CSS wcr specific objects [\#417](https://github.com/DEFRA/waste-carriers-back-office/pull/417) ([cintamani](https://github.com/cintamani))
- Make dashboard CSS class names less generic [\#406](https://github.com/DEFRA/waste-carriers-back-office/pull/406) ([irisfaraway](https://github.com/irisfaraway))
- Add 'inactive' tag text [\#391](https://github.com/DEFRA/waste-carriers-back-office/pull/391) ([irisfaraway](https://github.com/irisfaraway))
- Display correct number of results on dashboard [\#390](https://github.com/DEFRA/waste-carriers-back-office/pull/390) ([irisfaraway](https://github.com/irisfaraway))
- Improve contrast on 'expired' tag [\#389](https://github.com/DEFRA/waste-carriers-back-office/pull/389) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Fix renew link in registration details page [\#481](https://github.com/DEFRA/waste-carriers-back-office/pull/481) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `2e0559f` to `af80154` [\#480](https://github.com/DEFRA/waste-carriers-back-office/pull/480) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8bd459d` to `2e0559f` [\#477](https://github.com/DEFRA/waste-carriers-back-office/pull/477) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use classes instead of objects in ability specs [\#472](https://github.com/DEFRA/waste-carriers-back-office/pull/472) ([irisfaraway](https://github.com/irisfaraway))
- Update ActionLinksHelper to use cleaner methods [\#471](https://github.com/DEFRA/waste-carriers-back-office/pull/471) ([irisfaraway](https://github.com/irisfaraway))
- Move last sections to partials in details page [\#468](https://github.com/DEFRA/waste-carriers-back-office/pull/468) ([cintamani](https://github.com/cintamani))
- Refactor ability specs [\#467](https://github.com/DEFRA/waste-carriers-back-office/pull/467) ([irisfaraway](https://github.com/irisfaraway))
- Move rejected message status into partial [\#466](https://github.com/DEFRA/waste-carriers-back-office/pull/466) ([cintamani](https://github.com/cintamani))
- Move shared panels to partials on details page views [\#465](https://github.com/DEFRA/waste-carriers-back-office/pull/465) ([cintamani](https://github.com/cintamani))
- Move company details panel to partial [\#464](https://github.com/DEFRA/waste-carriers-back-office/pull/464) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `37db211` to `8bd459d` [\#461](https://github.com/DEFRA/waste-carriers-back-office/pull/461) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add ceased/revoked info box to view details pages [\#460](https://github.com/DEFRA/waste-carriers-back-office/pull/460) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `ca3f078` to `37db211` [\#454](https://github.com/DEFRA/waste-carriers-back-office/pull/454) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Create presenter for RenewingRegistration details page [\#453](https://github.com/DEFRA/waste-carriers-back-office/pull/453) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `05629b7` to `ca3f078` [\#451](https://github.com/DEFRA/waste-carriers-back-office/pull/451) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `05de6ed` to `05629b7` [\#450](https://github.com/DEFRA/waste-carriers-back-office/pull/450) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bb047bd` to `05de6ed` [\#446](https://github.com/DEFRA/waste-carriers-back-office/pull/446) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Use correct `small-bold` class [\#443](https://github.com/DEFRA/waste-carriers-back-office/pull/443) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `9b67fef` to `bb047bd` [\#442](https://github.com/DEFRA/waste-carriers-back-office/pull/442) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refactor RegistrationTransferService to inherit from BaseService [\#440](https://github.com/DEFRA/waste-carriers-back-office/pull/440) ([irisfaraway](https://github.com/irisfaraway))
- Refactor UserMigrationService to inherit from BaseService [\#439](https://github.com/DEFRA/waste-carriers-back-office/pull/439) ([irisfaraway](https://github.com/irisfaraway))
- Remove dupe BaseService [\#438](https://github.com/DEFRA/waste-carriers-back-office/pull/438) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `54105a5` to `9b67fef` [\#437](https://github.com/DEFRA/waste-carriers-back-office/pull/437) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3d0f18a` to `54105a5` [\#436](https://github.com/DEFRA/waste-carriers-back-office/pull/436) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `54e95e4` to `5aabe85` [\#433](https://github.com/DEFRA/waste-carriers-back-office/pull/433) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4100eed` to `54e95e4` [\#430](https://github.com/DEFRA/waste-carriers-back-office/pull/430) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ebc0f97` to `4100eed` [\#429](https://github.com/DEFRA/waste-carriers-back-office/pull/429) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Registration details page - People section [\#427](https://github.com/DEFRA/waste-carriers-back-office/pull/427) ([cintamani](https://github.com/cintamani))
- Remove about this renewal section in registration details page [\#416](https://github.com/DEFRA/waste-carriers-back-office/pull/416) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `0235664` to `ebc0f97` [\#415](https://github.com/DEFRA/waste-carriers-back-office/pull/415) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3a35c7a` to `0235664` [\#414](https://github.com/DEFRA/waste-carriers-back-office/pull/414) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump github\_changelog\_generator from 1.14.3 to 1.15.0 [\#410](https://github.com/DEFRA/waste-carriers-back-office/pull/410) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fc1acad` to `49586c1` [\#403](https://github.com/DEFRA/waste-carriers-back-office/pull/403) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Move action link paths to helper [\#400](https://github.com/DEFRA/waste-carriers-back-office/pull/400) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `7093d87` to `fc1acad` [\#398](https://github.com/DEFRA/waste-carriers-back-office/pull/398) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3f4036d` to `7093d87` [\#397](https://github.com/DEFRA/waste-carriers-back-office/pull/397) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8d4bedf` to `3f4036d` [\#396](https://github.com/DEFRA/waste-carriers-back-office/pull/396) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7207901` to `8d4bedf` [\#395](https://github.com/DEFRA/waste-carriers-back-office/pull/395) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `dfc460b` to `7207901` [\#392](https://github.com/DEFRA/waste-carriers-back-office/pull/392) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3dfb753` to `dfc460b` [\#388](https://github.com/DEFRA/waste-carriers-back-office/pull/388) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a8531ed` to `63641e7` [\#383](https://github.com/DEFRA/waste-carriers-back-office/pull/383) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `9c6ef6f` to `a8531ed` [\#380](https://github.com/DEFRA/waste-carriers-back-office/pull/380) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `f13dabe` to `9c6ef6f` [\#379](https://github.com/DEFRA/waste-carriers-back-office/pull/379) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rspec-rails from 3.8.2 to 3.9.0 [\#375](https://github.com/DEFRA/waste-carriers-back-office/pull/375) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5065d33` to `f13dabe` [\#374](https://github.com/DEFRA/waste-carriers-back-office/pull/374) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b682608` to `5065d33` [\#373](https://github.com/DEFRA/waste-carriers-back-office/pull/373) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d06e77c` to `b682608` [\#372](https://github.com/DEFRA/waste-carriers-back-office/pull/372) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `f6bbdff` to `d06e77c` [\#371](https://github.com/DEFRA/waste-carriers-back-office/pull/371) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.1.0 to 5.1.1 [\#370](https://github.com/DEFRA/waste-carriers-back-office/pull/370) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.2 to 0.1.3 [\#369](https://github.com/DEFRA/waste-carriers-back-office/pull/369) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `744ebed` to `f6bbdff` [\#368](https://github.com/DEFRA/waste-carriers-back-office/pull/368) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.20 to 4.2.0 [\#367](https://github.com/DEFRA/waste-carriers-back-office/pull/367) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8928098` to `744ebed` [\#366](https://github.com/DEFRA/waste-carriers-back-office/pull/366) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.0.2 to 5.1.0 [\#365](https://github.com/DEFRA/waste-carriers-back-office/pull/365) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `15a2d01` to `8928098` [\#364](https://github.com/DEFRA/waste-carriers-back-office/pull/364) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump turbolinks from 5.2.0 to 5.2.1 [\#363](https://github.com/DEFRA/waste-carriers-back-office/pull/363) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump simplecov from 0.17.0 to 0.17.1 [\#362](https://github.com/DEFRA/waste-carriers-back-office/pull/362) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.5.1](https://github.com/defra/waste-carriers-back-office/tree/v1.5.1) (2019-09-13)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.5.0...v1.5.1)

**Fixed bugs:**

- Add missing companies house configuration [\#361](https://github.com/DEFRA/waste-carriers-back-office/pull/361) ([Cruikshanks](https://github.com/Cruikshanks))

**Security fixes:**

- \[Security\] Bump devise from 4.7.0 to 4.7.1 [\#358](https://github.com/DEFRA/waste-carriers-back-office/pull/358) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `c666b9a` to `15a2d01` [\#360](https://github.com/DEFRA/waste-carriers-back-office/pull/360) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `49f25cc` to `c666b9a` [\#359](https://github.com/DEFRA/waste-carriers-back-office/pull/359) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5dea1e6` to `49f25cc` [\#357](https://github.com/DEFRA/waste-carriers-back-office/pull/357) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `14c7080` to `5dea1e6` [\#356](https://github.com/DEFRA/waste-carriers-back-office/pull/356) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8bbf501` to `14c7080` [\#355](https://github.com/DEFRA/waste-carriers-back-office/pull/355) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `34986aa` to `8bbf501` [\#354](https://github.com/DEFRA/waste-carriers-back-office/pull/354) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `926c925` to `34986aa` [\#353](https://github.com/DEFRA/waste-carriers-back-office/pull/353) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `793bbfb` to `926c925` [\#352](https://github.com/DEFRA/waste-carriers-back-office/pull/352) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update Travis-CI badge url in README [\#351](https://github.com/DEFRA/waste-carriers-back-office/pull/351) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `e729d87` to `793bbfb` [\#350](https://github.com/DEFRA/waste-carriers-back-office/pull/350) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.6.2 to 4.7.0 [\#349](https://github.com/DEFRA/waste-carriers-back-office/pull/349) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.5.0](https://github.com/defra/waste-carriers-back-office/tree/v1.5.0) (2019-08-15)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.4.3...v1.5.0)

**Implemented enhancements:**

- Update date on verbal privacy policy [\#348](https://github.com/DEFRA/waste-carriers-back-office/pull/348) ([Cruikshanks](https://github.com/Cruikshanks))
- Add privacy policy page for renewals [\#340](https://github.com/DEFRA/waste-carriers-back-office/pull/340) ([cintamani](https://github.com/cintamani))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `2ade67a` to `e729d87` [\#347](https://github.com/DEFRA/waste-carriers-back-office/pull/347) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `06a3f20` to `2ade67a` [\#346](https://github.com/DEFRA/waste-carriers-back-office/pull/346) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `723d42a` to `06a3f20` [\#344](https://github.com/DEFRA/waste-carriers-back-office/pull/344) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0d43d16` to `723d42a` [\#343](https://github.com/DEFRA/waste-carriers-back-office/pull/343) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.4 to 2.7.5 [\#342](https://github.com/DEFRA/waste-carriers-back-office/pull/342) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b3ff8fc` to `0d43d16` [\#341](https://github.com/DEFRA/waste-carriers-back-office/pull/341) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `61acc6d` to `b3ff8fc` [\#339](https://github.com/DEFRA/waste-carriers-back-office/pull/339) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b03350d` to `61acc6d` [\#338](https://github.com/DEFRA/waste-carriers-back-office/pull/338) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump simplecov from 0.16.1 to 0.17.0 [\#337](https://github.com/DEFRA/waste-carriers-back-office/pull/337) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a0c211c` to `b03350d` [\#336](https://github.com/DEFRA/waste-carriers-back-office/pull/336) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.4.3](https://github.com/defra/waste-carriers-back-office/tree/v1.4.3) (2019-06-25)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.4.2...v1.4.3)

**Fixed bugs:**

- Fix persistence of updated session token after logout [\#328](https://github.com/DEFRA/waste-carriers-back-office/pull/328) ([irisfaraway](https://github.com/irisfaraway))
- Save session token change to database [\#321](https://github.com/DEFRA/waste-carriers-back-office/pull/321) ([irisfaraway](https://github.com/irisfaraway))
- Add test coverage for correct handling of 404 errors [\#307](https://github.com/DEFRA/waste-carriers-back-office/pull/307) ([cintamani](https://github.com/cintamani))

**Security fixes:**

- \[Security\] Bump nokogiri from 1.10.2 to 1.10.3 [\#302](https://github.com/DEFRA/waste-carriers-back-office/pull/302) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `65a0536` to `a0c211c` [\#335](https://github.com/DEFRA/waste-carriers-back-office/pull/335) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.2 to 2.7.4 [\#334](https://github.com/DEFRA/waste-carriers-back-office/pull/334) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6f4fdc0` to `65a0536` [\#333](https://github.com/DEFRA/waste-carriers-back-office/pull/333) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump spring from 2.0.2 to 2.1.0 [\#331](https://github.com/DEFRA/waste-carriers-back-office/pull/331) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump jquery-rails from 4.3.3 to 4.3.5 [\#330](https://github.com/DEFRA/waste-carriers-back-office/pull/330) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `590a2d0` to `6f4fdc0` [\#329](https://github.com/DEFRA/waste-carriers-back-office/pull/329) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5c9a7aa` to `590a2d0` [\#327](https://github.com/DEFRA/waste-carriers-back-office/pull/327) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4496849` to `5c9a7aa` [\#326](https://github.com/DEFRA/waste-carriers-back-office/pull/326) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.1 to 0.1.2 [\#325](https://github.com/DEFRA/waste-carriers-back-office/pull/325) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `944b634` to `4496849` [\#324](https://github.com/DEFRA/waste-carriers-back-office/pull/324) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `490e016` to `944b634` [\#323](https://github.com/DEFRA/waste-carriers-back-office/pull/323) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Fix database cleaner to keep the test environment clean at every test [\#322](https://github.com/DEFRA/waste-carriers-back-office/pull/322) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `3ee239e` to `490e016` [\#320](https://github.com/DEFRA/waste-carriers-back-office/pull/320) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `196d1c6` to `3ee239e` [\#319](https://github.com/DEFRA/waste-carriers-back-office/pull/319) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c9b4501` to `196d1c6` [\#318](https://github.com/DEFRA/waste-carriers-back-office/pull/318) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2562c16` to `c9b4501` [\#317](https://github.com/DEFRA/waste-carriers-back-office/pull/317) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Switch to new engine repo name [\#315](https://github.com/DEFRA/waste-carriers-back-office/pull/315) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `2380260` to `2562c16` [\#314](https://github.com/DEFRA/waste-carriers-back-office/pull/314) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump jbuilder from 2.8.0 to 2.9.1 [\#312](https://github.com/DEFRA/waste-carriers-back-office/pull/312) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `12ab94e` to `2380260` [\#310](https://github.com/DEFRA/waste-carriers-back-office/pull/310) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Revert "Add test coverage for correct handling of 404 errors" [\#309](https://github.com/DEFRA/waste-carriers-back-office/pull/309) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `76850e9` to `12ab94e` [\#308](https://github.com/DEFRA/waste-carriers-back-office/pull/308) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove byebug and swap it with pry-byebug [\#306](https://github.com/DEFRA/waste-carriers-back-office/pull/306) ([cintamani](https://github.com/cintamani))
- Bump waste\_carriers\_engine from `959dc89` to `76850e9` [\#305](https://github.com/DEFRA/waste-carriers-back-office/pull/305) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0b6b053` to `959dc89` [\#304](https://github.com/DEFRA/waste-carriers-back-office/pull/304) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Make back to payment exception uniform [\#303](https://github.com/DEFRA/waste-carriers-back-office/pull/303) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `3066255` to `0b6b053` [\#301](https://github.com/DEFRA/waste-carriers-back-office/pull/301) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8156cb0` to `3066255` [\#300](https://github.com/DEFRA/waste-carriers-back-office/pull/300) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.0.1 to 5.0.2 [\#299](https://github.com/DEFRA/waste-carriers-back-office/pull/299) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `db6bec5` to `8156cb0` [\#297](https://github.com/DEFRA/waste-carriers-back-office/pull/297) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.4.2](https://github.com/defra/waste-carriers-back-office/tree/v1.4.2) (2019-04-05)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.4.1...v1.4.2)

**Fixed bugs:**

- Fix Airbrake for the dev environment [\#287](https://github.com/DEFRA/waste-carriers-back-office/pull/287) ([Cruikshanks](https://github.com/Cruikshanks))

**Security fixes:**

- \[Security\] Bump rails from 4.2.11 to 4.2.11.1 [\#279](https://github.com/DEFRA/waste-carriers-back-office/pull/279) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `7f89bbe` to `db6bec5` [\#296](https://github.com/DEFRA/waste-carriers-back-office/pull/296) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c0fc86d` to `7f89bbe` [\#295](https://github.com/DEFRA/waste-carriers-back-office/pull/295) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.1.0 to 0.1.1 [\#294](https://github.com/DEFRA/waste-carriers-back-office/pull/294) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `feccea3` to `c0fc86d` [\#293](https://github.com/DEFRA/waste-carriers-back-office/pull/293) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6e7bed0` to `feccea3` [\#292](https://github.com/DEFRA/waste-carriers-back-office/pull/292) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.6.1 to 4.6.2 [\#291](https://github.com/DEFRA/waste-carriers-back-office/pull/291) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e17e257` to `6e7bed0` [\#290](https://github.com/DEFRA/waste-carriers-back-office/pull/290) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.7.1 to 2.7.2 [\#289](https://github.com/DEFRA/waste-carriers-back-office/pull/289) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fd979fb` to `e17e257` [\#286](https://github.com/DEFRA/waste-carriers-back-office/pull/286) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.0.3 to 0.1.0 [\#282](https://github.com/DEFRA/waste-carriers-back-office/pull/282) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump byebug from 11.0.0 to 11.0.1 [\#281](https://github.com/DEFRA/waste-carriers-back-office/pull/281) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fcfb145` to `fd979fb` [\#278](https://github.com/DEFRA/waste-carriers-back-office/pull/278) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Unlock Rails version [\#277](https://github.com/DEFRA/waste-carriers-back-office/pull/277) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `5e9cafa` to `fcfb145` [\#276](https://github.com/DEFRA/waste-carriers-back-office/pull/276) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0e475f6` to `5e9cafa` [\#275](https://github.com/DEFRA/waste-carriers-back-office/pull/275) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump govuk\_template from 0.25.0 to 0.26.0 [\#274](https://github.com/DEFRA/waste-carriers-back-office/pull/274) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove dummy secret key logic in application.rb [\#273](https://github.com/DEFRA/waste-carriers-back-office/pull/273) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `ac97859` to `0e475f6` [\#272](https://github.com/DEFRA/waste-carriers-back-office/pull/272) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump defra\_ruby\_style from 0.0.2 to 0.0.3 [\#271](https://github.com/DEFRA/waste-carriers-back-office/pull/271) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3778978` to `ac97859` [\#270](https://github.com/DEFRA/waste-carriers-back-office/pull/270) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `461f71d` to `3778978` [\#269](https://github.com/DEFRA/waste-carriers-back-office/pull/269) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.6.0 to 2.7.1 [\#267](https://github.com/DEFRA/waste-carriers-back-office/pull/267) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1166d2f` to `461f71d` [\#266](https://github.com/DEFRA/waste-carriers-back-office/pull/266) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a6071c2` to `1166d2f` [\#265](https://github.com/DEFRA/waste-carriers-back-office/pull/265) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump byebug from 10.0.2 to 11.0.0 [\#264](https://github.com/DEFRA/waste-carriers-back-office/pull/264) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `1bc4489` to `a6071c2` [\#263](https://github.com/DEFRA/waste-carriers-back-office/pull/263) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.6.0 to 4.6.1 [\#262](https://github.com/DEFRA/waste-carriers-back-office/pull/262) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0d9df12` to `1bc4489` [\#260](https://github.com/DEFRA/waste-carriers-back-office/pull/260) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 5.0.0 to 5.0.1 [\#258](https://github.com/DEFRA/waste-carriers-back-office/pull/258) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.5.0 to 4.6.0 [\#257](https://github.com/DEFRA/waste-carriers-back-office/pull/257) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c840601` to `0d9df12` [\#256](https://github.com/DEFRA/waste-carriers-back-office/pull/256) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Align rspec test setup with WEX [\#255](https://github.com/DEFRA/waste-carriers-back-office/pull/255) ([Cruikshanks](https://github.com/Cruikshanks))
- Remove passenger from dev group in Gemfile [\#254](https://github.com/DEFRA/waste-carriers-back-office/pull/254) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `ee64b70` to `c840601` [\#253](https://github.com/DEFRA/waste-carriers-back-office/pull/253) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 4.11.1 to 5.0.0 [\#252](https://github.com/DEFRA/waste-carriers-back-office/pull/252) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `64f8472` to `ee64b70` [\#251](https://github.com/DEFRA/waste-carriers-back-office/pull/251) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `517539b` to `64f8472` [\#250](https://github.com/DEFRA/waste-carriers-back-office/pull/250) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.4.1](https://github.com/defra/waste-carriers-back-office/tree/v1.4.1) (2019-01-25)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.4.0...v1.4.1)

**Merged pull requests:**

- Bump rspec-rails from 3.8.1 to 3.8.2 [\#249](https://github.com/DEFRA/waste-carriers-back-office/pull/249) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4ccdb83` to `517539b` [\#248](https://github.com/DEFRA/waste-carriers-back-office/pull/248) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `970b4ca` to `4ccdb83` [\#247](https://github.com/DEFRA/waste-carriers-back-office/pull/247) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump dotenv-rails from 2.5.0 to 2.6.0 [\#246](https://github.com/DEFRA/waste-carriers-back-office/pull/246) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Get defra-ruby-style from Rubygems [\#244](https://github.com/DEFRA/waste-carriers-back-office/pull/244) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `8cccfb7` to `970b4ca` [\#243](https://github.com/DEFRA/waste-carriers-back-office/pull/243) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `56ab415` to `8cccfb7` [\#241](https://github.com/DEFRA/waste-carriers-back-office/pull/241) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Install defra-ruby-style for linting [\#240](https://github.com/DEFRA/waste-carriers-back-office/pull/240) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `6cc5541` to `56ab415` [\#239](https://github.com/DEFRA/waste-carriers-back-office/pull/239) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Lock Travis to bundler 1.x [\#238](https://github.com/DEFRA/waste-carriers-back-office/pull/238) ([irisfaraway](https://github.com/irisfaraway))
- Bump rubocop from 0.61.1 to 0.62.0 [\#236](https://github.com/DEFRA/waste-carriers-back-office/pull/236) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `131aff3` to `6cc5541` [\#225](https://github.com/DEFRA/waste-carriers-back-office/pull/225) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6813c1c` to `131aff3` [\#224](https://github.com/DEFRA/waste-carriers-back-office/pull/224) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.4.0](https://github.com/defra/waste-carriers-back-office/tree/v1.4.0) (2018-12-11)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.3.1...v1.4.0)

**Implemented enhancements:**

- Add status in dashboard for stuck renewals [\#217](https://github.com/DEFRA/waste-carriers-back-office/pull/217) ([Cruikshanks](https://github.com/Cruikshanks))
- Allow finance admin users to add 'stuck' WorldPay payments [\#210](https://github.com/DEFRA/waste-carriers-back-office/pull/210) ([irisfaraway](https://github.com/irisfaraway))
- Refactor AdminFormsController options [\#209](https://github.com/DEFRA/waste-carriers-back-office/pull/209) ([irisfaraway](https://github.com/irisfaraway))
- List oldest renewals first on convictions dashboard [\#208](https://github.com/DEFRA/waste-carriers-back-office/pull/208) ([irisfaraway](https://github.com/irisfaraway))
- Change redirect paths after conviction check action [\#207](https://github.com/DEFRA/waste-carriers-back-office/pull/207) ([irisfaraway](https://github.com/irisfaraway))
- Remove conviction status from dashboard search filters [\#203](https://github.com/DEFRA/waste-carriers-back-office/pull/203) ([irisfaraway](https://github.com/irisfaraway))
- Manage new conviction workflow [\#202](https://github.com/DEFRA/waste-carriers-back-office/pull/202) ([irisfaraway](https://github.com/irisfaraway))
- Add convictions overview page [\#197](https://github.com/DEFRA/waste-carriers-back-office/pull/197) ([irisfaraway](https://github.com/irisfaraway))
- Add workflow states to conviction\_sign\_offs [\#196](https://github.com/DEFRA/waste-carriers-back-office/pull/196) ([irisfaraway](https://github.com/irisfaraway))
- Clarify user migration content [\#195](https://github.com/DEFRA/waste-carriers-back-office/pull/195) ([irisfaraway](https://github.com/irisfaraway))
- Improve dashboard search performance [\#191](https://github.com/DEFRA/waste-carriers-back-office/pull/191) ([Cruikshanks](https://github.com/Cruikshanks))
- Allow super users to migrate users from backend [\#187](https://github.com/DEFRA/waste-carriers-back-office/pull/187) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Refactor logic around can renew/complete checks [\#216](https://github.com/DEFRA/waste-carriers-back-office/pull/216) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix err msg WCR Engine::VERSION already defined [\#201](https://github.com/DEFRA/waste-carriers-back-office/pull/201) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix web console error in development log [\#200](https://github.com/DEFRA/waste-carriers-back-office/pull/200) ([Cruikshanks](https://github.com/Cruikshanks))

**Security fixes:**

- Upgrade to Rails 4.2.11 [\#213](https://github.com/DEFRA/waste-carriers-back-office/pull/213) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `2c31d00` to `6813c1c` [\#223](https://github.com/DEFRA/waste-carriers-back-office/pull/223) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Rescue CanCan::AccessDenied by redirecting to correct page [\#222](https://github.com/DEFRA/waste-carriers-back-office/pull/222) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `1a03190` to `2c31d00` [\#221](https://github.com/DEFRA/waste-carriers-back-office/pull/221) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.61.0 to 0.61.1 [\#220](https://github.com/DEFRA/waste-carriers-back-office/pull/220) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.60.0 to 0.61.0 [\#219](https://github.com/DEFRA/waste-carriers-back-office/pull/219) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7b53a24` to `1bc515c` [\#218](https://github.com/DEFRA/waste-carriers-back-office/pull/218) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `7e0608b` to `7b53a24` [\#215](https://github.com/DEFRA/waste-carriers-back-office/pull/215) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `a99cf42` to `5fc5e29` [\#211](https://github.com/DEFRA/waste-carriers-back-office/pull/211) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `4725917` to `a99cf42` [\#205](https://github.com/DEFRA/waste-carriers-back-office/pull/205) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bc72860` to `4725917` [\#204](https://github.com/DEFRA/waste-carriers-back-office/pull/204) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `5ec634a` to `9de9bd7` [\#199](https://github.com/DEFRA/waste-carriers-back-office/pull/199) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ecdea2e` to `a692a19` [\#198](https://github.com/DEFRA/waste-carriers-back-office/pull/198) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e283ec6` to `3542e08` [\#194](https://github.com/DEFRA/waste-carriers-back-office/pull/194) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.19 to 4.1.20 [\#193](https://github.com/DEFRA/waste-carriers-back-office/pull/193) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove rake email anonymiser task [\#192](https://github.com/DEFRA/waste-carriers-back-office/pull/192) ([Cruikshanks](https://github.com/Cruikshanks))

## [v1.3.1](https://github.com/defra/waste-carriers-back-office/tree/v1.3.1) (2018-11-16)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.3.0...v1.3.1)

**Merged pull requests:**

- Bump waste\_carriers\_engine from `d83e3b4` to `e283ec6` [\#190](https://github.com/DEFRA/waste-carriers-back-office/pull/190) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `b95d5ce` to `d83e3b4` [\#189](https://github.com/DEFRA/waste-carriers-back-office/pull/189) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c9d8c00` to `b95d5ce` [\#188](https://github.com/DEFRA/waste-carriers-back-office/pull/188) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.3.0](https://github.com/defra/waste-carriers-back-office/tree/v1.3.0) (2018-11-12)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.2.3...v1.3.0)

**Implemented enhancements:**

- Add rake task to sync internal users [\#182](https://github.com/DEFRA/waste-carriers-back-office/pull/182) ([Cruikshanks](https://github.com/Cruikshanks))
- Add new page for user management [\#180](https://github.com/DEFRA/waste-carriers-back-office/pull/180) ([irisfaraway](https://github.com/irisfaraway))
- Add a menu to the back office [\#178](https://github.com/DEFRA/waste-carriers-back-office/pull/178) ([irisfaraway](https://github.com/irisfaraway))
- Add ability to skip already anonymised emails [\#173](https://github.com/DEFRA/waste-carriers-back-office/pull/173) ([Cruikshanks](https://github.com/Cruikshanks))
- Ensure output to STDOUT is immediate in anonymise [\#172](https://github.com/DEFRA/waste-carriers-back-office/pull/172) ([Cruikshanks](https://github.com/Cruikshanks))
- Add timings and alter output in anonymise email task [\#170](https://github.com/DEFRA/waste-carriers-back-office/pull/170) ([Cruikshanks](https://github.com/Cruikshanks))
- Add rake task to anonymise emails [\#165](https://github.com/DEFRA/waste-carriers-back-office/pull/165) ([Cruikshanks](https://github.com/Cruikshanks))
- Add config for renewal grace window [\#164](https://github.com/DEFRA/waste-carriers-back-office/pull/164) ([Cruikshanks](https://github.com/Cruikshanks))
- Transfer a registration to a new account [\#161](https://github.com/DEFRA/waste-carriers-back-office/pull/161) ([irisfaraway](https://github.com/irisfaraway))
- Transfer a registration to an existing account [\#153](https://github.com/DEFRA/waste-carriers-back-office/pull/153) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Remove active styling from menu links [\#186](https://github.com/DEFRA/waste-carriers-back-office/pull/186) ([irisfaraway](https://github.com/irisfaraway))
- Use new env var to get backend path [\#185](https://github.com/DEFRA/waste-carriers-back-office/pull/185) ([irisfaraway](https://github.com/irisfaraway))
- Downcase all email characters when transferring registration [\#179](https://github.com/DEFRA/waste-carriers-back-office/pull/179) ([irisfaraway](https://github.com/irisfaraway))
- Fix blocked actions post grace window [\#169](https://github.com/DEFRA/waste-carriers-back-office/pull/169) ([Cruikshanks](https://github.com/Cruikshanks))
- Add rake task to solve stuck renewals [\#162](https://github.com/DEFRA/waste-carriers-back-office/pull/162) ([Cruikshanks](https://github.com/Cruikshanks))

**Security fixes:**

- \[Security\] Bump rack from 1.6.10 to 1.6.11 [\#166](https://github.com/DEFRA/waste-carriers-back-office/pull/166) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump loofah from 2.2.2 to 2.2.3 [\#159](https://github.com/DEFRA/waste-carriers-back-office/pull/159) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `b535c6c` to `c9d8c00` [\#184](https://github.com/DEFRA/waste-carriers-back-office/pull/184) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump passenger from 5.3.6 to 5.3.7 [\#183](https://github.com/DEFRA/waste-carriers-back-office/pull/183) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump govuk\_template from 0.24.1 to 0.25.0 [\#177](https://github.com/DEFRA/waste-carriers-back-office/pull/177) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `e5d5f42` to `80a323f` [\#171](https://github.com/DEFRA/waste-carriers-back-office/pull/171) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump jbuilder from 2.7.0 to 2.8.0 [\#168](https://github.com/DEFRA/waste-carriers-back-office/pull/168) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump passenger from 5.3.5 to 5.3.6 [\#167](https://github.com/DEFRA/waste-carriers-back-office/pull/167) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `74171af` to `307ebcf` [\#160](https://github.com/DEFRA/waste-carriers-back-office/pull/160) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.59.2 to 0.60.0 [\#158](https://github.com/DEFRA/waste-carriers-back-office/pull/158) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `bec6d58` to `74171af` [\#157](https://github.com/DEFRA/waste-carriers-back-office/pull/157) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2.3](https://github.com/defra/waste-carriers-back-office/tree/v1.2.3) (2018-10-24)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.2.2...v1.2.3)

**Merged pull requests:**

- Bump rspec-rails from 3.8.0 to 3.8.1 [\#156](https://github.com/DEFRA/waste-carriers-back-office/pull/156) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fd941fb` to `bec6d58` [\#155](https://github.com/DEFRA/waste-carriers-back-office/pull/155) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2.2](https://github.com/defra/waste-carriers-back-office/tree/v1.2.2) (2018-10-19)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.2.1...v1.2.2)

**Implemented enhancements:**

- Use paging in fix dupe house no. rake task [\#152](https://github.com/DEFRA/waste-carriers-back-office/pull/152) ([Cruikshanks](https://github.com/Cruikshanks))
- Display expiry date of registration in back office [\#151](https://github.com/DEFRA/waste-carriers-back-office/pull/151) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Improve address update rake task [\#150](https://github.com/DEFRA/waste-carriers-back-office/pull/150) ([irisfaraway](https://github.com/irisfaraway))
- Add missing translation for overseas business types [\#145](https://github.com/DEFRA/waste-carriers-back-office/pull/145) ([irisfaraway](https://github.com/irisfaraway))
- Add rake task to fix addresses in incorrect format [\#143](https://github.com/DEFRA/waste-carriers-back-office/pull/143) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `231e839` to `fd941fb` [\#149](https://github.com/DEFRA/waste-carriers-back-office/pull/149) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise\_invitable from 1.7.4 to 1.7.5 [\#148](https://github.com/DEFRA/waste-carriers-back-office/pull/148) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d6b6696` to `231e839` [\#146](https://github.com/DEFRA/waste-carriers-back-office/pull/146) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `3565d4e` to `d6b6696` [\#144](https://github.com/DEFRA/waste-carriers-back-office/pull/144) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2.1](https://github.com/defra/waste-carriers-back-office/tree/v1.2.1) (2018-10-11)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.2...v1.2.1)

**Fixed bugs:**

- Use shared displayable\_address method for displaying addresses [\#141](https://github.com/DEFRA/waste-carriers-back-office/pull/141) ([irisfaraway](https://github.com/irisfaraway))
-  Don't automatically list all renewals in back office dashboard [\#140](https://github.com/DEFRA/waste-carriers-back-office/pull/140) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `4297b34` to `3565d4e` [\#142](https://github.com/DEFRA/waste-carriers-back-office/pull/142) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `0f1f11b` to `4297b34` [\#139](https://github.com/DEFRA/waste-carriers-back-office/pull/139) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.2](https://github.com/defra/waste-carriers-back-office/tree/v1.2) (2018-10-05)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.1...v1.2)

**Implemented enhancements:**

- Agency super users inherit normal agency permissions [\#138](https://github.com/DEFRA/waste-carriers-back-office/pull/138) ([irisfaraway](https://github.com/irisfaraway))
- NCCC users can send renewal stuck in WorldPay back to payment summary [\#136](https://github.com/DEFRA/waste-carriers-back-office/pull/136) ([irisfaraway](https://github.com/irisfaraway))

**Security fixes:**

- \[Security\] Bump nokogiri from 1.8.4 to 1.8.5 [\#134](https://github.com/DEFRA/waste-carriers-back-office/pull/134) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `75a23f7` to `0f1f11b` [\#137](https://github.com/DEFRA/waste-carriers-back-office/pull/137) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.1](https://github.com/defra/waste-carriers-back-office/tree/v1.1) (2018-09-27)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/v1.0...v1.1)

**Implemented enhancements:**

- Better renewal end screens for back office users [\#130](https://github.com/DEFRA/waste-carriers-back-office/pull/130) ([irisfaraway](https://github.com/irisfaraway))
- Clarify account\_email label on transient\_registration page [\#128](https://github.com/DEFRA/waste-carriers-back-office/pull/128) ([irisfaraway](https://github.com/irisfaraway))
- Invalidate user session cookies after logout [\#124](https://github.com/DEFRA/waste-carriers-back-office/pull/124) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Fix finish link not going to backend [\#132](https://github.com/DEFRA/waste-carriers-back-office/pull/132) ([Cruikshanks](https://github.com/Cruikshanks))
- Stop users accessing pages with back button after signout [\#125](https://github.com/DEFRA/waste-carriers-back-office/pull/125) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `9ed1a21` to `75a23f7` [\#131](https://github.com/DEFRA/waste-carriers-back-office/pull/131) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump passenger from 5.3.4 to 5.3.5 [\#129](https://github.com/DEFRA/waste-carriers-back-office/pull/129) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `ae7499f` to `9ed1a21` [\#127](https://github.com/DEFRA/waste-carriers-back-office/pull/127) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.59.1 to 0.59.2 [\#126](https://github.com/DEFRA/waste-carriers-back-office/pull/126) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))

## [v1.0](https://github.com/defra/waste-carriers-back-office/tree/v1.0) (2018-09-18)

[Full Changelog](https://github.com/defra/waste-carriers-back-office/compare/213225c8939e094def6e28ca2501cf9e556281ac...v1.0)

**Implemented enhancements:**

- Configure back-office to send emails via SendGrid [\#115](https://github.com/DEFRA/waste-carriers-back-office/pull/115) ([irisfaraway](https://github.com/irisfaraway))
- Add link to sign out [\#113](https://github.com/DEFRA/waste-carriers-back-office/pull/113) ([irisfaraway](https://github.com/irisfaraway))
- List in-progress registrations [\#76](https://github.com/DEFRA/waste-carriers-back-office/pull/76) ([irisfaraway](https://github.com/irisfaraway))
- Add specific support for ELB health check calls [\#70](https://github.com/DEFRA/waste-carriers-back-office/pull/70) ([Cruikshanks](https://github.com/Cruikshanks))
- Add Passenger web app server to project [\#21](https://github.com/DEFRA/waste-carriers-back-office/pull/21) ([Cruikshanks](https://github.com/Cruikshanks))
- Integrate the project with Codeclimate [\#2](https://github.com/DEFRA/waste-carriers-back-office/pull/2) ([Cruikshanks](https://github.com/Cruikshanks))
- Integrate with Travis-CI [\#1](https://github.com/DEFRA/waste-carriers-back-office/pull/1) ([Cruikshanks](https://github.com/Cruikshanks))

**Fixed bugs:**

- Set link for header title to be /bo [\#82](https://github.com/DEFRA/waste-carriers-back-office/pull/82) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix routing to ensure /bo/ path is included [\#75](https://github.com/DEFRA/waste-carriers-back-office/pull/75) ([Cruikshanks](https://github.com/Cruikshanks))
- Ignore Passengerfile.json [\#29](https://github.com/DEFRA/waste-carriers-back-office/pull/29) ([Cruikshanks](https://github.com/Cruikshanks))
- Airbrake/Errbit projecy env var wrong name [\#28](https://github.com/DEFRA/waste-carriers-back-office/pull/28) ([Cruikshanks](https://github.com/Cruikshanks))
- Fix changelog generator breaking deploy to heroku [\#27](https://github.com/DEFRA/waste-carriers-back-office/pull/27) ([Cruikshanks](https://github.com/Cruikshanks))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `d1ee300` to `ae7499f` [\#123](https://github.com/DEFRA/waste-carriers-back-office/pull/123) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `c67419b` to `d1ee300` [\#121](https://github.com/DEFRA/waste-carriers-back-office/pull/121) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `8667cef` to `c67419b` [\#120](https://github.com/DEFRA/waste-carriers-back-office/pull/120) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.59.0 to 0.59.1 [\#116](https://github.com/DEFRA/waste-carriers-back-office/pull/116) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6d5713b` to `8667cef` [\#114](https://github.com/DEFRA/waste-carriers-back-office/pull/114) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.18 to 4.1.19 [\#112](https://github.com/DEFRA/waste-carriers-back-office/pull/112) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `f33eaaf` to `6d5713b` [\#111](https://github.com/DEFRA/waste-carriers-back-office/pull/111) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 4.11.0 to 4.11.1 [\#110](https://github.com/DEFRA/waste-carriers-back-office/pull/110) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.58.2 to 0.59.0 [\#109](https://github.com/DEFRA/waste-carriers-back-office/pull/109) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Renewals are completed once there are no pending issues [\#108](https://github.com/DEFRA/waste-carriers-back-office/pull/108) ([irisfaraway](https://github.com/irisfaraway))
- Finance\_admin users can record missed WorldPay payment [\#107](https://github.com/DEFRA/waste-carriers-back-office/pull/107) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record postal order payment [\#106](https://github.com/DEFRA/waste-carriers-back-office/pull/106) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record cheque payment [\#105](https://github.com/DEFRA/waste-carriers-back-office/pull/105) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record cash payment [\#104](https://github.com/DEFRA/waste-carriers-back-office/pull/104) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `3a2ac10` to `f33eaaf` [\#103](https://github.com/DEFRA/waste-carriers-back-office/pull/103) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Seed back office users from json file [\#102](https://github.com/DEFRA/waste-carriers-back-office/pull/102) ([Cruikshanks](https://github.com/Cruikshanks))
- Back office users can select which type of payment they want to add [\#101](https://github.com/DEFRA/waste-carriers-back-office/pull/101) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `e158484` to `3a2ac10` [\#100](https://github.com/DEFRA/waste-carriers-back-office/pull/100) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `2d39589` to `e158484` [\#99](https://github.com/DEFRA/waste-carriers-back-office/pull/99) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `9a8822b` to `2d39589` [\#98](https://github.com/DEFRA/waste-carriers-back-office/pull/98) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Finance users can record electronic bank transfer payment [\#97](https://github.com/DEFRA/waste-carriers-back-office/pull/97) ([irisfaraway](https://github.com/irisfaraway))
- Set up roles for back office users [\#96](https://github.com/DEFRA/waste-carriers-back-office/pull/96) ([irisfaraway](https://github.com/irisfaraway))
- Let user continue to renewal after logging in [\#95](https://github.com/DEFRA/waste-carriers-back-office/pull/95) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `ad6efb6` to `9a8822b` [\#94](https://github.com/DEFRA/waste-carriers-back-office/pull/94) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Users can approve or reject based on convictions [\#93](https://github.com/DEFRA/waste-carriers-back-office/pull/93) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `ff379ae` to `ad6efb6` [\#92](https://github.com/DEFRA/waste-carriers-back-office/pull/92) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add page showing conviction match details [\#91](https://github.com/DEFRA/waste-carriers-back-office/pull/91) ([irisfaraway](https://github.com/irisfaraway))
- Back office dashboard QA fixes [\#90](https://github.com/DEFRA/waste-carriers-back-office/pull/90) ([irisfaraway](https://github.com/irisfaraway))
- Fix header link on pages using engine [\#89](https://github.com/DEFRA/waste-carriers-back-office/pull/89) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `c0aa771` to `ff379ae` [\#88](https://github.com/DEFRA/waste-carriers-back-office/pull/88) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Update deprecated static attributes in factories [\#87](https://github.com/DEFRA/waste-carriers-back-office/pull/87) ([irisfaraway](https://github.com/irisfaraway))
- Bump turbolinks from 5.1.1 to 5.2.0 [\#86](https://github.com/DEFRA/waste-carriers-back-office/pull/86) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `058ac7f` to `c0aa771` [\#85](https://github.com/DEFRA/waste-carriers-back-office/pull/85) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 4.10.0 to 4.11.0 [\#84](https://github.com/DEFRA/waste-carriers-back-office/pull/84) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `6a8414e` to `058ac7f` [\#83](https://github.com/DEFRA/waste-carriers-back-office/pull/83) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump devise from 4.4.3 to 4.5.0 [\#81](https://github.com/DEFRA/waste-carriers-back-office/pull/81) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Implement search for in-progress renewals [\#80](https://github.com/DEFRA/waste-carriers-back-office/pull/80) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `bd1f376` to `6a8414e` [\#79](https://github.com/DEFRA/waste-carriers-back-office/pull/79) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
-  Improve list of transient regs on dashboard [\#78](https://github.com/DEFRA/waste-carriers-back-office/pull/78) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `642fee6` to `bd1f376` [\#77](https://github.com/DEFRA/waste-carriers-back-office/pull/77) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `09d21f7` to `642fee6` [\#74](https://github.com/DEFRA/waste-carriers-back-office/pull/74) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `fcb4475` to `09d21f7` [\#73](https://github.com/DEFRA/waste-carriers-back-office/pull/73) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.17 to 4.1.18 [\#72](https://github.com/DEFRA/waste-carriers-back-office/pull/72) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Change seed email [\#71](https://github.com/DEFRA/waste-carriers-back-office/pull/71) ([irisfaraway](https://github.com/irisfaraway))
- Enable force\_ssl in production [\#69](https://github.com/DEFRA/waste-carriers-back-office/pull/69) ([Cruikshanks](https://github.com/Cruikshanks))
- Back office users can see details of a transient registration [\#68](https://github.com/DEFRA/waste-carriers-back-office/pull/68) ([irisfaraway](https://github.com/irisfaraway))
- Switch from govuk\_admin\_template to govuk\_template [\#67](https://github.com/DEFRA/waste-carriers-back-office/pull/67) ([irisfaraway](https://github.com/irisfaraway))
- Airbrake can be switched on or off [\#66](https://github.com/DEFRA/waste-carriers-back-office/pull/66) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `c8a2a9e` to `fcb4475` [\#65](https://github.com/DEFRA/waste-carriers-back-office/pull/65) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Remove simple\_form [\#64](https://github.com/DEFRA/waste-carriers-back-office/pull/64) ([irisfaraway](https://github.com/irisfaraway))
- Configure secure headers [\#63](https://github.com/DEFRA/waste-carriers-back-office/pull/63) ([irisfaraway](https://github.com/irisfaraway))
- Add specific page titles to template [\#62](https://github.com/DEFRA/waste-carriers-back-office/pull/62) ([irisfaraway](https://github.com/irisfaraway))
- Configure devise-invitable [\#61](https://github.com/DEFRA/waste-carriers-back-office/pull/61) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `2215c20` to `c8a2a9e` [\#60](https://github.com/DEFRA/waste-carriers-back-office/pull/60) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Set config value for metaData.route [\#59](https://github.com/DEFRA/waste-carriers-back-office/pull/59) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `337f3d1` to `2215c20` [\#58](https://github.com/DEFRA/waste-carriers-back-office/pull/58) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rspec-rails from 3.7.2 to 3.8.0 [\#57](https://github.com/DEFRA/waste-carriers-back-office/pull/57) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Set up users for the back office [\#56](https://github.com/DEFRA/waste-carriers-back-office/pull/56) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `8e389be` to `337f3d1` [\#55](https://github.com/DEFRA/waste-carriers-back-office/pull/55) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Set the host in application config [\#54](https://github.com/DEFRA/waste-carriers-back-office/pull/54) ([irisfaraway](https://github.com/irisfaraway))
- Use WEBrick in test environment [\#53](https://github.com/DEFRA/waste-carriers-back-office/pull/53) ([irisfaraway](https://github.com/irisfaraway))
- Fix link in banner [\#52](https://github.com/DEFRA/waste-carriers-back-office/pull/52) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `d8b6576` to `8e389be` [\#51](https://github.com/DEFRA/waste-carriers-back-office/pull/51) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Move dashboard to /bo [\#50](https://github.com/DEFRA/waste-carriers-back-office/pull/50) ([irisfaraway](https://github.com/irisfaraway))
- Bump passenger from 5.3.3 to 5.3.4 [\#49](https://github.com/DEFRA/waste-carriers-back-office/pull/49) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
-  Mount renewals engine in a directory, not root [\#48](https://github.com/DEFRA/waste-carriers-back-office/pull/48) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `cf3d8ce` to `37d42eb` [\#47](https://github.com/DEFRA/waste-carriers-back-office/pull/47) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Move users out of engine [\#46](https://github.com/DEFRA/waste-carriers-back-office/pull/46) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `047a7c4` to `cf3d8ce` [\#45](https://github.com/DEFRA/waste-carriers-back-office/pull/45) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.16 to 4.1.17 [\#44](https://github.com/DEFRA/waste-carriers-back-office/pull/44) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `38dd85a` to `047a7c4` [\#43](https://github.com/DEFRA/waste-carriers-back-office/pull/43) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `d0281f2` to `38dd85a` [\#42](https://github.com/DEFRA/waste-carriers-back-office/pull/42) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Add branch to WCR renewals Gemfile entry [\#41](https://github.com/DEFRA/waste-carriers-back-office/pull/41) ([Cruikshanks](https://github.com/Cruikshanks))
- Set secret\_key\_base when run under prod & rake [\#40](https://github.com/DEFRA/waste-carriers-back-office/pull/40) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump rubocop from 0.58.1 to 0.58.2 [\#38](https://github.com/DEFRA/waste-carriers-back-office/pull/38) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump waste\_carriers\_engine from `51ffa99` to `ced04a0` [\#37](https://github.com/DEFRA/waste-carriers-back-office/pull/37) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.14 to 4.1.16 [\#34](https://github.com/DEFRA/waste-carriers-back-office/pull/34) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump rubocop from 0.57.2 to 0.58.1 [\#32](https://github.com/DEFRA/waste-carriers-back-office/pull/32) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Sync dev and test secret keys across WCR service [\#26](https://github.com/DEFRA/waste-carriers-back-office/pull/26) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `a1c4067` to `51ffa99` [\#25](https://github.com/DEFRA/waste-carriers-back-office/pull/25) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Refactor mongoid config to use URI's [\#24](https://github.com/DEFRA/waste-carriers-back-office/pull/24) ([Cruikshanks](https://github.com/Cruikshanks))
- Mount renewals journey in back office [\#22](https://github.com/DEFRA/waste-carriers-back-office/pull/22) ([irisfaraway](https://github.com/irisfaraway))
- Bump uglifier from 4.1.13 to 4.1.14 [\#20](https://github.com/DEFRA/waste-carriers-back-office/pull/20) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.12 to 4.1.13 [\#19](https://github.com/DEFRA/waste-carriers-back-office/pull/19) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Standardise environment variables [\#18](https://github.com/DEFRA/waste-carriers-back-office/pull/18) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump dotenv-rails from 2.4.0 to 2.5.0 [\#17](https://github.com/DEFRA/waste-carriers-back-office/pull/17) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump uglifier from 4.1.11 to 4.1.12 [\#16](https://github.com/DEFRA/waste-carriers-back-office/pull/16) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- \[Security\] Bump sprockets from 3.7.1 to 3.7.2 [\#15](https://github.com/DEFRA/waste-carriers-back-office/pull/15) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Swap example port for port used in Vagrant env [\#14](https://github.com/DEFRA/waste-carriers-back-office/pull/14) ([Cruikshanks](https://github.com/Cruikshanks))
- Update RSpec config [\#13](https://github.com/DEFRA/waste-carriers-back-office/pull/13) ([irisfaraway](https://github.com/irisfaraway))
- Update Rubocop config [\#12](https://github.com/DEFRA/waste-carriers-back-office/pull/12) ([irisfaraway](https://github.com/irisfaraway))
- Bump rubocop from 0.57.1 to 0.57.2 [\#11](https://github.com/DEFRA/waste-carriers-back-office/pull/11) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Bump factory\_bot\_rails from 4.8.2 to 4.10.0 [\#10](https://github.com/DEFRA/waste-carriers-back-office/pull/10) ([dependabot-preview[bot]](https://github.com/apps/dependabot-preview))
- Set up authentication using Devise [\#4](https://github.com/DEFRA/waste-carriers-back-office/pull/4) ([irisfaraway](https://github.com/irisfaraway))
- Add GDS admin styling [\#3](https://github.com/DEFRA/waste-carriers-back-office/pull/3) ([irisfaraway](https://github.com/irisfaraway))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
