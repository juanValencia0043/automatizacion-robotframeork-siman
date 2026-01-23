*** Variables ***

${INPUT_VTEX_LOGIN}                id=email
${BTN_CONTINUE_VTEX_LOGIN}         css=button[class*='vtex-button']
${INPUT_VTEX_TOKEN}                css=input[class*="vtex-admin-login-3NBORj9E0vpp-gi0D1V2Ng"]
${BTN_SUBMIT_VTEX_LOGIN}           css=button[class*='vtex-button']

${FRAME_mail7}                   xpath=//*[@id="ifmail"]
${PARAGRAPH_WITH_OTP}              xpath=//*[@id="mail"]/div/div[2]/table/tbody/tr/td/table/tbody/tr/td/div/p[2]    
${INPUT_mail7}                   id=login
${BTN_CHECK_mail7}               css=div[id='refreshbut'] > button
${BTN_REFRESH_mail7}             id=refresh
${EMAIL_CHECKBOX_mail7}          xpath=//input[@class='mc']
${BTN_DELETE_mail7}              id=delsel
${FRAME_MAILS_LIST}                id=ifinbox

${LOGIN_GOOGLE}                    id=google-oauth

