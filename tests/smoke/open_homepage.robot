*** Settings ***
Documentation    Verifica que la página de inicio de Siman.com carga correctamente.
Resource    ../../resources/keywords/browser_keywords.resource
Resource    ../../resources/variables/environment.resource
Resource    ../../resources/locators/home_locators.resource

Test Setup      Open Browser To Homepage
Test Teardown   Close Browser

*** Test Cases ***
Validate Home Page Loads
    [Documentation]    Abre la web y valida que el logo esté visible.
    Wait Until Page Contains Element    ${HEADER_LOGO}    ${TIMEOUT}
    Log To Console    ✅ Página cargada con éxito.
