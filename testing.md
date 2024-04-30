# USER TESTING - MODULA (25/07/2023)

## Sign Up
- Application successfully signs the user up with expected inputs.
- Redundant username signup allowed.
- Validation checks:
    - Email check implemented and working.
    - User name validation not implemented, accepts special characters.
    - Password validation implemented and working.
    - Redundant phone number allowed.
    - Accepts unregistered emails.
- Google signup/login not working.

## Login Page
- Login page works well with expected inputs.
- Does not accept registered username.
- Accepts registered email only.

## Situation (Logged In)
### Home Page
- Static display is good and clear.
- System feedback is clear upon selecting a video.
#### Issues
- Profile picture is static display only and not saved or displayed upon logging in again.
- Generating Video:
  #### Issues
    - No system feedback to put in appropriate FPS for video type.
    - Max FPS set at 30, takes a lot of time upon selecting 10-30 FPS.
    - Works best with FPS<10.
    - No backward navigation button (application closes upon pressing the default backward button of mobile).

### Profile Page
- Everything static is displayed well and oriented.
#### Issues
- Profile picture is not saved or displayed upon logging in again.

### Terms and Conditions
- Everything else is up to the mark.
- No backward navigation button (application closes upon pressing the default backward button of mobile).

### Privacy Policy
- Everything else is up to the mark.
- No backward navigation button (application closes upon pressing the default backward button of mobile).

### Logout
- Logout button is working as expected.

## Suggestions
- Addition of a backward navigation button to allow easy navigation.
- Add a link shift to the profile page upon clicking the profile picture in the home page.
- Implement a login persistence mechanism, so the user is directly logged in when the application reopens.

----------------------------------------------------------------------------------------------------

# USER TESTING - MODULA (27/07/2023)

| Issues                   | Status | Comments                                             |
|--------------------------|--------|------------------------------------------------------|
| Google Sign In           | ❌     | Same issue persists upon logging in / signing up via Google. |
| Automatic Login          | ✔️     | Works as expected.                                   |
| Backward Navigation Button |        |                                                      |
| - View All               | ✔️     |                                                      |
| - Profile Page           | ❌     | No backward navigation as mentioned in the previous report. |
| - Privacy Statement Page | ❌     |                                                      |
| - Terms and Conditions Page | ❌    |                                                      |
| Clickable Profile Icon   | ❌     | Profile Icon displayed but not clickable.           |
| Update on System Feedback upon: |        |                                                      |
| - Selecting Video        | ✔️     | User may select settings which might be unfavorable for the application. |
| - Generating Video       | ✔️     |                                                      |


Profile Page:
- Upon selecting a custom profile picture, the image disappears upon logging in again.
- It appears that the image is being stored locally but not being fetched from the cloud.
Done by Abdul Wahab


