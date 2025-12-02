*** Variables ***

${INPUT_VTEX_LOGIN}                id=email
${BTN_CONTINUE_VTEX_LOGIN}         css=button[class*='vtex-button']
${INPUT_VTEX_TOKEN}                css=input[class*="vtex-admin-login-3NBORj9E0vpp-gi0D1V2Ng"]
${BTN_SUBMIT_VTEX_LOGIN}           css=button[class*='vtex-button']

${FRAME_YOPMAIL}                   xpath=//*[@id="ifmail"]
${PARAGRAPH_WITH_OTP}              xpath=//*[@id="mail"]/div/div[2]/table/tbody/tr/td/table/tbody/tr/td/div/p[2]    
${INPUT_YOPMAIL}                   id=login
${BTN_CHECK_YOPMAIL}               css=div[id='refreshbut'] > button

