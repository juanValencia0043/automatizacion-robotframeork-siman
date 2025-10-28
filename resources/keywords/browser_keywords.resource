*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Checkout
    [Arguments]     ${cart_type}
    [Documentation]    Abre checkout según el environment (prod o sandbox)
    
    # Determinar las URLs basado en el environment
    ${checkout_url}=    Set Variable If
        # PRODUCCIÓN
        ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'small'              ${CHECKOUT_PROD_SMALL}
        ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'small_mk'           ${CHECKOUT_PROD_SMALL_MK}
        ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'big'                ${CHECKOUT_PROD_BIG}
        ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'split_siman'        ${CHECKOUT_PROD_SPLIT_SIMAN}
        ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'split_siman_mk'     ${CHECKOUT_PROD_SPLIT_SIMAN_MK}
        # SANDBOX  
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'small'           ${CHECKOUT_SANDBOX_SMALL}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'small_mk'        ${CHECKOUT_SANDBOX_SMALL_MK}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'big'             ${CHECKOUT_SANDBOX_BIG}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_siman'     ${CHECKOUT_SANDBOX_SPLIT_SIMAN}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_siman_mk'  ${CHECKOUT_SANDBOX_SPLIT_SIMAN_MK}
        # DEFAULT (fallback)
        ...    ${CHECKOUT_PROD_SMALL}

    Open Browser With Options    ${checkout_url}
    Log To Console    ✅ [${ENVIRONMENT}] Carrito ${cart_type} cargado: ${checkout_url}


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