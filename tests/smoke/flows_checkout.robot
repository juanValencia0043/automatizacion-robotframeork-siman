*** Settings ***
Documentation    Verifica que la página de inicio de Siman.com carga correctamente.
Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/variables/environment.resource
Resource    ../../resources/variables/checkout_urls.resource
Resource    ../../resources/locators/home_locators.resource
Resource    ../../resources/locators/checkout_locators.resource


Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small
    Open Browser To Checkout    small 
    Sleep    3s  # Pausa adicional
    Click Element By Type    ${BTN_GO_PAYMENT}    button

    