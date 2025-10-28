*** Settings ***
Documentation    Verifica flujos principales en Checkout.

Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/keywords/checkout_keywords.resource


Resource    ../../resources/variables/environment.resource
Resource    ../../resources/variables/checkout_urls.resource

Resource    ../../resources/locators/home_locators.resource
Resource    ../../resources/locators/checkout_locators.resource


Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small Ticket
    Open Browser To Checkout    small 
    Click Element By Type   ${BTN_GO_PAYMENT}    button
    Login Checkout  new_user
    