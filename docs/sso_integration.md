# SSO Integration

For local setup of SSO integration follow the steps described below.

## MOJ SSO

* Clone [MOJ SSO](https://github.com/ministryofjustice/moj-sso) and follow the setup instructions
* Run the MOJ SSO application:

  ```bash
  bundle exec rails s -p 5000
  ```

* Ensure _Moving People Safely_ as an **application** exists in the MOJ SSO database (the **client identifier** and **secret** will be needed later on)
* Ensure there's a _Moving People Safely_ **team** (under MOJ > NOMS > Digital) that has access to the _Moving People Safely_ **application**
* Ensure there's at least one **user** that belong to the _Moving People Safely_ **team** so it can be used to authenticate in the _Moving People Safely_ **application**

# Moving People Safely

* Setup the environment variables needed to integration with _SSO_ **application**:

**NOTE:** Retrieve the `MOJSSO_ID` and `MOJSSO_SECRET` values from the _MOJ SSO_ configuration for the _Moving People Safely_ **application**

  ```bash
  MOJSSO_URL=http://localhost:5000
  MOJSSO_ID=e7811860b189683fcb54331134dfa3c1a8cc63ce5ea9449b1e432aec9ff964b3
  MOJSSO_SECRET=bc9a6060172d35013fe614f4f2e89f9064f614a6e4b155821406aa4713e7f132
  ```

* Run the _Moving People Safely_ **application**:

  ```bash
  bundle exec rails s -p 3000
  ```

* Click the link 'Start now' (you should be redirected to the MOJ SSO login page)
* Authenticate using the **user** that belongs to the _Moving People Safely_ **team** in the _MOJ SSO_ **application**
* You should be successfully logged in
