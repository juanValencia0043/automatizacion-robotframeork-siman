*** Settings ***
Library    SeleniumLibrary
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/locators/checkout_locators.resource
Resource    ../../resources/variables/testdata.resource

*** Keywords ***
Login Checkout
    [Arguments]    ${user_type}
    [Documentation]    Metodo general para logearse en checkout ya sea como usuario recurrente o no 
    
    Sleep    2s 
    IF    '${user_type}' == 'new_user'
        ${random_email}    Create Random Email
        Fill Element By Text    ${INPUT_EMAIL}    ${random_email}
        Click Element By Type    ${INPUT_NAME}    other
        Fill Element By Text    ${INPUT_NAME}    ${NAME}
        Fill Element By Text    ${INPUT_LAST_NAME}    ${LAST_NAME}
        Select List Item    ${SELECT_DOCUMENT}    ${DUI}
        Fill Element By Text    ${INPUT_DOCUMENT}     ${DOCUMENT}
        Fill Element By Text    ${INPUT_PHONE}    ${PHONE}
        Click Element By Type    ${CHECK_PRIVACY_TERMS}    checkbox
        Click Element By Type   ${BTN_GO_SHIPPING}    button        
    ELSE IF    '${user_type}' == 'recurrent_user'
        Fill Element By Text    ${INPUT_EMAIL}    ${EMAIL_RECURRENT}
    END




