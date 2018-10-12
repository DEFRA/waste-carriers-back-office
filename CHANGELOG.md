# Change Log

## [v1.2.1](https://github.com/DEFRA/waste-carriers-back-office/tree/v1.2.1) (2018-10-11)
[Full Changelog](https://github.com/DEFRA/waste-carriers-back-office/compare/v1.2...v1.2.1)

**Fixed bugs:**

- Use shared displayable\_address method for displaying addresses [\#141](https://github.com/DEFRA/waste-carriers-back-office/pull/141) ([irisfaraway](https://github.com/irisfaraway))
-  Don't automatically list all renewals in back office dashboard [\#140](https://github.com/DEFRA/waste-carriers-back-office/pull/140) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `4297b34` to `3565d4e` [\#142](https://github.com/DEFRA/waste-carriers-back-office/pull/142) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `0f1f11b` to `4297b34` [\#139](https://github.com/DEFRA/waste-carriers-back-office/pull/139) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v1.2](https://github.com/DEFRA/waste-carriers-back-office/tree/v1.2) (2018-10-05)
[Full Changelog](https://github.com/DEFRA/waste-carriers-back-office/compare/v1.1...v1.2)

**Implemented enhancements:**

- Agency super users inherit normal agency permissions [\#138](https://github.com/DEFRA/waste-carriers-back-office/pull/138) ([irisfaraway](https://github.com/irisfaraway))
- NCCC users can send renewal stuck in WorldPay back to payment summary [\#136](https://github.com/DEFRA/waste-carriers-back-office/pull/136) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `75a23f7` to `0f1f11b` [\#137](https://github.com/DEFRA/waste-carriers-back-office/pull/137) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[Security\] Bump nokogiri from 1.8.4 to 1.8.5 [\#134](https://github.com/DEFRA/waste-carriers-back-office/pull/134) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v1.1](https://github.com/DEFRA/waste-carriers-back-office/tree/v1.1) (2018-09-27)
[Full Changelog](https://github.com/DEFRA/waste-carriers-back-office/compare/v1.0...v1.1)

**Implemented enhancements:**

- Better renewal end screens for back office users [\#130](https://github.com/DEFRA/waste-carriers-back-office/pull/130) ([irisfaraway](https://github.com/irisfaraway))
- Clarify account\_email label on transient\_registration page [\#128](https://github.com/DEFRA/waste-carriers-back-office/pull/128) ([irisfaraway](https://github.com/irisfaraway))
- Invalidate user session cookies after logout [\#124](https://github.com/DEFRA/waste-carriers-back-office/pull/124) ([irisfaraway](https://github.com/irisfaraway))

**Fixed bugs:**

- Fix finish link not going to backend [\#132](https://github.com/DEFRA/waste-carriers-back-office/pull/132) ([Cruikshanks](https://github.com/Cruikshanks))
- Stop users accessing pages with back button after signout [\#125](https://github.com/DEFRA/waste-carriers-back-office/pull/125) ([irisfaraway](https://github.com/irisfaraway))

**Merged pull requests:**

- Bump waste\_carriers\_engine from `9ed1a21` to `75a23f7` [\#131](https://github.com/DEFRA/waste-carriers-back-office/pull/131) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump passenger from 5.3.4 to 5.3.5 [\#129](https://github.com/DEFRA/waste-carriers-back-office/pull/129) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `ae7499f` to `9ed1a21` [\#127](https://github.com/DEFRA/waste-carriers-back-office/pull/127) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop from 0.59.1 to 0.59.2 [\#126](https://github.com/DEFRA/waste-carriers-back-office/pull/126) ([dependabot[bot]](https://github.com/apps/dependabot))

## [v1.0](https://github.com/DEFRA/waste-carriers-back-office/tree/v1.0) (2018-09-18)
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

- Bump waste\_carriers\_engine from `d1ee300` to `ae7499f` [\#123](https://github.com/DEFRA/waste-carriers-back-office/pull/123) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `c67419b` to `d1ee300` [\#121](https://github.com/DEFRA/waste-carriers-back-office/pull/121) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `8667cef` to `c67419b` [\#120](https://github.com/DEFRA/waste-carriers-back-office/pull/120) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop from 0.59.0 to 0.59.1 [\#116](https://github.com/DEFRA/waste-carriers-back-office/pull/116) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `6d5713b` to `8667cef` [\#114](https://github.com/DEFRA/waste-carriers-back-office/pull/114) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.18 to 4.1.19 [\#112](https://github.com/DEFRA/waste-carriers-back-office/pull/112) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `f33eaaf` to `6d5713b` [\#111](https://github.com/DEFRA/waste-carriers-back-office/pull/111) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 4.11.0 to 4.11.1 [\#110](https://github.com/DEFRA/waste-carriers-back-office/pull/110) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop from 0.58.2 to 0.59.0 [\#109](https://github.com/DEFRA/waste-carriers-back-office/pull/109) ([dependabot[bot]](https://github.com/apps/dependabot))
- Renewals are completed once there are no pending issues [\#108](https://github.com/DEFRA/waste-carriers-back-office/pull/108) ([irisfaraway](https://github.com/irisfaraway))
- Finance\_admin users can record missed WorldPay payment [\#107](https://github.com/DEFRA/waste-carriers-back-office/pull/107) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record postal order payment [\#106](https://github.com/DEFRA/waste-carriers-back-office/pull/106) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record cheque payment [\#105](https://github.com/DEFRA/waste-carriers-back-office/pull/105) ([irisfaraway](https://github.com/irisfaraway))
- Agency users can record cash payment [\#104](https://github.com/DEFRA/waste-carriers-back-office/pull/104) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `3a2ac10` to `f33eaaf` [\#103](https://github.com/DEFRA/waste-carriers-back-office/pull/103) ([dependabot[bot]](https://github.com/apps/dependabot))
- Seed back office users from json file [\#102](https://github.com/DEFRA/waste-carriers-back-office/pull/102) ([Cruikshanks](https://github.com/Cruikshanks))
- Back office users can select which type of payment they want to add [\#101](https://github.com/DEFRA/waste-carriers-back-office/pull/101) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `e158484` to `3a2ac10` [\#100](https://github.com/DEFRA/waste-carriers-back-office/pull/100) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `2d39589` to `e158484` [\#99](https://github.com/DEFRA/waste-carriers-back-office/pull/99) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `9a8822b` to `2d39589` [\#98](https://github.com/DEFRA/waste-carriers-back-office/pull/98) ([dependabot[bot]](https://github.com/apps/dependabot))
- Finance users can record electronic bank transfer payment [\#97](https://github.com/DEFRA/waste-carriers-back-office/pull/97) ([irisfaraway](https://github.com/irisfaraway))
- Set up roles for back office users [\#96](https://github.com/DEFRA/waste-carriers-back-office/pull/96) ([irisfaraway](https://github.com/irisfaraway))
- Let user continue to renewal after logging in [\#95](https://github.com/DEFRA/waste-carriers-back-office/pull/95) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `ad6efb6` to `9a8822b` [\#94](https://github.com/DEFRA/waste-carriers-back-office/pull/94) ([dependabot[bot]](https://github.com/apps/dependabot))
- Users can approve or reject based on convictions [\#93](https://github.com/DEFRA/waste-carriers-back-office/pull/93) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `ff379ae` to `ad6efb6` [\#92](https://github.com/DEFRA/waste-carriers-back-office/pull/92) ([dependabot[bot]](https://github.com/apps/dependabot))
- Add page showing conviction match details [\#91](https://github.com/DEFRA/waste-carriers-back-office/pull/91) ([irisfaraway](https://github.com/irisfaraway))
- Back office dashboard QA fixes [\#90](https://github.com/DEFRA/waste-carriers-back-office/pull/90) ([irisfaraway](https://github.com/irisfaraway))
- Fix header link on pages using engine [\#89](https://github.com/DEFRA/waste-carriers-back-office/pull/89) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `c0aa771` to `ff379ae` [\#88](https://github.com/DEFRA/waste-carriers-back-office/pull/88) ([dependabot[bot]](https://github.com/apps/dependabot))
- Update deprecated static attributes in factories [\#87](https://github.com/DEFRA/waste-carriers-back-office/pull/87) ([irisfaraway](https://github.com/irisfaraway))
- Bump turbolinks from 5.1.1 to 5.2.0 [\#86](https://github.com/DEFRA/waste-carriers-back-office/pull/86) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `058ac7f` to `c0aa771` [\#85](https://github.com/DEFRA/waste-carriers-back-office/pull/85) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 4.10.0 to 4.11.0 [\#84](https://github.com/DEFRA/waste-carriers-back-office/pull/84) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `6a8414e` to `058ac7f` [\#83](https://github.com/DEFRA/waste-carriers-back-office/pull/83) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump devise from 4.4.3 to 4.5.0 [\#81](https://github.com/DEFRA/waste-carriers-back-office/pull/81) ([dependabot[bot]](https://github.com/apps/dependabot))
- Implement search for in-progress renewals [\#80](https://github.com/DEFRA/waste-carriers-back-office/pull/80) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `bd1f376` to `6a8414e` [\#79](https://github.com/DEFRA/waste-carriers-back-office/pull/79) ([dependabot[bot]](https://github.com/apps/dependabot))
-  Improve list of transient regs on dashboard [\#78](https://github.com/DEFRA/waste-carriers-back-office/pull/78) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `642fee6` to `bd1f376` [\#77](https://github.com/DEFRA/waste-carriers-back-office/pull/77) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `09d21f7` to `642fee6` [\#74](https://github.com/DEFRA/waste-carriers-back-office/pull/74) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `fcb4475` to `09d21f7` [\#73](https://github.com/DEFRA/waste-carriers-back-office/pull/73) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.17 to 4.1.18 [\#72](https://github.com/DEFRA/waste-carriers-back-office/pull/72) ([dependabot[bot]](https://github.com/apps/dependabot))
- Change seed email [\#71](https://github.com/DEFRA/waste-carriers-back-office/pull/71) ([irisfaraway](https://github.com/irisfaraway))
- Enable force\_ssl in production [\#69](https://github.com/DEFRA/waste-carriers-back-office/pull/69) ([Cruikshanks](https://github.com/Cruikshanks))
- Back office users can see details of a transient registration [\#68](https://github.com/DEFRA/waste-carriers-back-office/pull/68) ([irisfaraway](https://github.com/irisfaraway))
- Switch from govuk\_admin\_template to govuk\_template [\#67](https://github.com/DEFRA/waste-carriers-back-office/pull/67) ([irisfaraway](https://github.com/irisfaraway))
- Airbrake can be switched on or off [\#66](https://github.com/DEFRA/waste-carriers-back-office/pull/66) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `c8a2a9e` to `fcb4475` [\#65](https://github.com/DEFRA/waste-carriers-back-office/pull/65) ([dependabot[bot]](https://github.com/apps/dependabot))
- Remove simple\_form [\#64](https://github.com/DEFRA/waste-carriers-back-office/pull/64) ([irisfaraway](https://github.com/irisfaraway))
- Configure secure headers [\#63](https://github.com/DEFRA/waste-carriers-back-office/pull/63) ([irisfaraway](https://github.com/irisfaraway))
- Add specific page titles to template [\#62](https://github.com/DEFRA/waste-carriers-back-office/pull/62) ([irisfaraway](https://github.com/irisfaraway))
- Configure devise-invitable [\#61](https://github.com/DEFRA/waste-carriers-back-office/pull/61) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `2215c20` to `c8a2a9e` [\#60](https://github.com/DEFRA/waste-carriers-back-office/pull/60) ([dependabot[bot]](https://github.com/apps/dependabot))
- Set config value for metaData.route [\#59](https://github.com/DEFRA/waste-carriers-back-office/pull/59) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `337f3d1` to `2215c20` [\#58](https://github.com/DEFRA/waste-carriers-back-office/pull/58) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rspec-rails from 3.7.2 to 3.8.0 [\#57](https://github.com/DEFRA/waste-carriers-back-office/pull/57) ([dependabot[bot]](https://github.com/apps/dependabot))
- Set up users for the back office [\#56](https://github.com/DEFRA/waste-carriers-back-office/pull/56) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `8e389be` to `337f3d1` [\#55](https://github.com/DEFRA/waste-carriers-back-office/pull/55) ([dependabot[bot]](https://github.com/apps/dependabot))
- Set the host in application config [\#54](https://github.com/DEFRA/waste-carriers-back-office/pull/54) ([irisfaraway](https://github.com/irisfaraway))
- Use WEBrick in test environment [\#53](https://github.com/DEFRA/waste-carriers-back-office/pull/53) ([irisfaraway](https://github.com/irisfaraway))
- Fix link in banner [\#52](https://github.com/DEFRA/waste-carriers-back-office/pull/52) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `d8b6576` to `8e389be` [\#51](https://github.com/DEFRA/waste-carriers-back-office/pull/51) ([dependabot[bot]](https://github.com/apps/dependabot))
- Move dashboard to /bo [\#50](https://github.com/DEFRA/waste-carriers-back-office/pull/50) ([irisfaraway](https://github.com/irisfaraway))
- Bump passenger from 5.3.3 to 5.3.4 [\#49](https://github.com/DEFRA/waste-carriers-back-office/pull/49) ([dependabot[bot]](https://github.com/apps/dependabot))
-  Mount renewals engine in a directory, not root [\#48](https://github.com/DEFRA/waste-carriers-back-office/pull/48) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `cf3d8ce` to `37d42eb` [\#47](https://github.com/DEFRA/waste-carriers-back-office/pull/47) ([dependabot[bot]](https://github.com/apps/dependabot))
- Move users out of engine [\#46](https://github.com/DEFRA/waste-carriers-back-office/pull/46) ([irisfaraway](https://github.com/irisfaraway))
- Bump waste\_carriers\_engine from `047a7c4` to `cf3d8ce` [\#45](https://github.com/DEFRA/waste-carriers-back-office/pull/45) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.16 to 4.1.17 [\#44](https://github.com/DEFRA/waste-carriers-back-office/pull/44) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `38dd85a` to `047a7c4` [\#43](https://github.com/DEFRA/waste-carriers-back-office/pull/43) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `d0281f2` to `38dd85a` [\#42](https://github.com/DEFRA/waste-carriers-back-office/pull/42) ([dependabot[bot]](https://github.com/apps/dependabot))
- Add branch to WCR renewals Gemfile entry [\#41](https://github.com/DEFRA/waste-carriers-back-office/pull/41) ([Cruikshanks](https://github.com/Cruikshanks))
- Set secret\_key\_base when run under prod & rake [\#40](https://github.com/DEFRA/waste-carriers-back-office/pull/40) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump rubocop from 0.58.1 to 0.58.2 [\#38](https://github.com/DEFRA/waste-carriers-back-office/pull/38) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump waste\_carriers\_engine from `51ffa99` to `ced04a0` [\#37](https://github.com/DEFRA/waste-carriers-back-office/pull/37) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.14 to 4.1.16 [\#34](https://github.com/DEFRA/waste-carriers-back-office/pull/34) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump rubocop from 0.57.2 to 0.58.1 [\#32](https://github.com/DEFRA/waste-carriers-back-office/pull/32) ([dependabot[bot]](https://github.com/apps/dependabot))
- Sync dev and test secret keys across WCR service [\#26](https://github.com/DEFRA/waste-carriers-back-office/pull/26) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump waste\_carriers\_engine from `a1c4067` to `51ffa99` [\#25](https://github.com/DEFRA/waste-carriers-back-office/pull/25) ([dependabot[bot]](https://github.com/apps/dependabot))
- Refactor mongoid config to use URI's [\#24](https://github.com/DEFRA/waste-carriers-back-office/pull/24) ([Cruikshanks](https://github.com/Cruikshanks))
- Mount renewals journey in back office [\#22](https://github.com/DEFRA/waste-carriers-back-office/pull/22) ([irisfaraway](https://github.com/irisfaraway))
- Bump uglifier from 4.1.13 to 4.1.14 [\#20](https://github.com/DEFRA/waste-carriers-back-office/pull/20) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.12 to 4.1.13 [\#19](https://github.com/DEFRA/waste-carriers-back-office/pull/19) ([dependabot[bot]](https://github.com/apps/dependabot))
- Standardise environment variables [\#18](https://github.com/DEFRA/waste-carriers-back-office/pull/18) ([Cruikshanks](https://github.com/Cruikshanks))
- Bump dotenv-rails from 2.4.0 to 2.5.0 [\#17](https://github.com/DEFRA/waste-carriers-back-office/pull/17) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump uglifier from 4.1.11 to 4.1.12 [\#16](https://github.com/DEFRA/waste-carriers-back-office/pull/16) ([dependabot[bot]](https://github.com/apps/dependabot))
- \[Security\] Bump sprockets from 3.7.1 to 3.7.2 [\#15](https://github.com/DEFRA/waste-carriers-back-office/pull/15) ([dependabot[bot]](https://github.com/apps/dependabot))
- Swap example port for port used in Vagrant env [\#14](https://github.com/DEFRA/waste-carriers-back-office/pull/14) ([Cruikshanks](https://github.com/Cruikshanks))
- Update RSpec config [\#13](https://github.com/DEFRA/waste-carriers-back-office/pull/13) ([irisfaraway](https://github.com/irisfaraway))
- Update Rubocop config [\#12](https://github.com/DEFRA/waste-carriers-back-office/pull/12) ([irisfaraway](https://github.com/irisfaraway))
- Bump rubocop from 0.57.1 to 0.57.2 [\#11](https://github.com/DEFRA/waste-carriers-back-office/pull/11) ([dependabot[bot]](https://github.com/apps/dependabot))
- Bump factory\_bot\_rails from 4.8.2 to 4.10.0 [\#10](https://github.com/DEFRA/waste-carriers-back-office/pull/10) ([dependabot[bot]](https://github.com/apps/dependabot))
- Set up authentication using Devise [\#4](https://github.com/DEFRA/waste-carriers-back-office/pull/4) ([irisfaraway](https://github.com/irisfaraway))
- Add GDS admin styling [\#3](https://github.com/DEFRA/waste-carriers-back-office/pull/3) ([irisfaraway](https://github.com/irisfaraway))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*