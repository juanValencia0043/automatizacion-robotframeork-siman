*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Checkout
    [Arguments]     ${cart_type}
    [Documentation]    Abre en modo incógnito según configuración
    
    ${checkout_url}=    Set Variable If
    ...    '${cart_type}' == 'small'              ${CHECKOUT_PROD_SMALL}
    ...    '${cart_type}' == 'small_mk'           ${CHECKOUT_PROD_SMALL_MK}
    ...    '${cart_type}' == 'big'                ${CHECKOUT_PROD_BIG}
    ...    '${cart_type}' == 'split_siman'        ${CHECKOUT_PROD_SPLIT_SIMAN}
    ...    '${cart_type}' == 'split_siman_mk'     ${CHECKOUT_PROD_SPLIT_SIMAN_MK} 

    Open Browser With Options    ${checkout_url}
    Log To Console    ✅ Carrito ${cart_type} cargado: ${checkout_url}

Open Browser With Options
    [Arguments]    ${url}
    [Documentation]    Abre navegador con opciones configuradas
    
    IF    '${BROWSER}' == 'chrome'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Run Keyword If    ${INCOGNITO_MODE}    Call Method    ${options}    add_argument    --incognito
    ELSE IF    '${BROWSER}' == 'firefox'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
        Run Keyword If    ${INCOGNITO_MODE}    Call Method    ${options}    add_argument    -private
    END
    
    # Opciones comunes
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    
    Open Browser    ${url}    ${BROWSER}    options=${options}
    Maximize Browser Window
