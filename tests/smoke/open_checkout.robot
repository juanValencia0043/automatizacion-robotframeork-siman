*** Settings ***
Documentation    Verifica que la página de inicio de Siman.com carga correctamente.
Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/variables/environment.resource
Resource    ../../resources/variables/checkout_urls.resource    # ¡IMPORTANTE!
Resource    ../../resources/locators/home_locators.resource

Test Teardown   Close Browser

*** Test Cases ***
Test Checkout Small
    Open Browser To Checkout    small    
    Log    ✅ Checkout small cargado correctamente