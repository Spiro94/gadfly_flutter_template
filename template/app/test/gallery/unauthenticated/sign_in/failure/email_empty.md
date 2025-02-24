<div data-description="container" data-description-level="0">
<div data-description="title">
<strong>EPIC</strong>:
unauthenticated
</div><div data-description="description">As a user, I need to be able to interact with the appication when I am unauthenticated.
</div></div>

<div data-description="container" data-description-level="1">
<div data-description="title">
<strong>STORY</strong>:
sign_in
</div><div data-description="description">As a user, I should be able to sign into the application.
</div></div>

<div data-description="container" data-description-level="2">
<div data-description="title">
<strong>AC</strong>:
failure
</div><div data-description="description">Signing in failed
</div></div>

<div data-description="container" data-description-level="3">
<div data-description="title">
<strong>scenario</strong>:
email_empty
</div><div data-description="description">The email is invalid
</div></div>

## initial state

<table>
  <tbody>
   <tr>
      <td width="300" style="vertical-align:top">
<b>Events:</b>
<ul>
  <li class=info>[app_builder] INFO: locale: en</li>
  <li class=info>[deep_link_handler] INFO: incoming deep link uri: /</li>
  <li class=info>[authenticated_guard] INFO: not authenticated</li>
  <li class=analytic>[ANALYTIC] [page]: SignIn_Route</li>
      </td>
      <td>
      <img width="300" src="../../../../flows/unauthenticated/screenshots/sign_in/failure/email_empty/0.0.iphone11.png">      </td>      </td>
      <td>
      <img width="300" src="../../../../flows/unauthenticated/screenshots/sign_in/failure/email_empty/0.1.iphone11.png">      </td>   </tr>
  </tbody>
</table>
## tap submit

<table>
  <tbody>
   <tr>
      <td width="300" style="vertical-align:top">
<b>User Actions:</b>
<ul>
  <li>Tapped: widget with type "SignIn_Button_Submit"</li>
</ul>
<b>Expect:</b>
<ul>
  <li>Should see email empty error</li>
  <li>Should see password empty error</li>
</ul>
<b>Events:</b>
<ul>
  <li class=info>[sign_in_form_sign_in] INFO: submitting form</li>
  <li class=warning>[sign_in_form_sign_in] WARNING: form not valid</li>
      </td>
      <td>
      <img width="300" src="../../../../flows/unauthenticated/screenshots/sign_in/failure/email_empty/1.0.iphone11.png">      </td>      </td>
      <td>
      <img width="300" src="../../../../flows/unauthenticated/screenshots/sign_in/failure/email_empty/1.1.iphone11.png">      </td>   </tr>
  </tbody>
</table>
