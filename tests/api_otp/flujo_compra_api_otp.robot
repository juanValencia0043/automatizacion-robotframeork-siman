*** Settings ***
Documentation       Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/mailsac_keywords.resource
Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource
Suite Setup    Disable SSL Warnings

Test Teardown   Close Browser

*** Test Cases ***
Test Obtanin OTP Mailsac
    [Tags]    CSC-9000  otp_mailsac
    ${email}=    Set Variable    pruebas_siman@mailsac.com
    ${otp}=    Obtener Codigo OTP Mailsac    ${email}
    Log To Console    El codigo OTP obtenido es: ${otp}