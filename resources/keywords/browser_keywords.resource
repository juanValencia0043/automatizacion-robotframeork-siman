*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Homepage
    [Documentation]    Abre el navegador y carga la URL base del entorno
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${HEADER_LOGO}    ${TIMEOUT}
    Log To Console    ✅ Página de inicio cargada correctamente

Close Browser
    [Documentation]    Cierra el navegador
    Close Browser
