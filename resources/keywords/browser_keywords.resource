*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/variables/checkout_urls.resource
Resource    ../../resources/variables/environment.resource


*** Keywords ***
Open Browser To Checkout
    [Arguments]     ${cart_type}        ${country}
    [Documentation]    Abre checkout según el environment (prod o sandbox)
    #Por default environment es sandbox
    IF    '${country}' == 'sv'
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
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_st_bt_mk'  ${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_st_moto'     ${CHECKOUT_SANDBOX_SPLIT_ST_MOTO}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_bt_moto'     ${CHECKOUT_SANDBOX_SPLIT_BT_MOTO}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_st_bt_moto'  ${CHECKOUT_SANDBOX_SPLIT_ST_BT_MOTO}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_mk_moto'     ${CHECKOUT_SANDBOX_SPLIT_MK_MOTO}
        ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_st_bt_mk_moto'  ${CHECKOUT_SANDBOX_SPLIT_ST_BT_MK_MOTO}
        # DEFAULT (fallback)
        ...    ${CHECKOUT_SANDBOX_ANY}
    ELSE IF    '${country}' == 'gt'
        ${checkout_url}=    Set Variable    ${CHECKOUT_SANDBOX_GT}
    ELSE IF    '${country}' == 'cr'
        ${checkout_url}=    Set Variable    ${CHECKOUT_SANDBOX_CR}
    ELSE IF    '${country}' == 'ni'
        ${checkout_url}=    Set Variable    ${CHECKOUT_SANDBOX_NI}
        
    END
    
    


    Open Browser With Options    ${checkout_url}
    Sleep    2s

Open Browser With Options
    [Documentation]    Abre navegador con opciones configuradas (Headless solo en CI)
    [Arguments]    ${url}

    # 1. Inicializar las opciones según el navegador
    IF    '${BROWSER}' == 'chrome'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        IF    ${INCOGNITO_MODE}
            Call Method    ${options}    add_argument    --incognito
        END
    ELSE IF    '${BROWSER}' == 'firefox'
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys, selenium.webdriver
        IF    ${INCOGNITO_MODE}
            Call Method    ${options}    add_argument    -private
        END
    END

    # 2. HEADLESS: Usamos comillas para asegurar que se pase como string
    # Nota: También puedes usar solo "--headless" si "--headless=new" te da problemas
    IF    '${CI}' == 'true'
        Call Method    ${options}    add_argument    --headless\=new
    END

    # 3. Opciones de estabilidad (Crucial para GitHub Actions)
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage

    # 4. Forzar el tamaño de ventana (evita que elementos no sean clickeables en headless)
    Call Method    ${options}    add_argument    --window-size\=1920,1080

    # 5. Abrir el navegador pasando el objeto de opciones correctamente
    Create Webdriver    ${BROWSER.capitalize()}    options=${options}
    Set Window Size    1920    1080  # <--- Agrega esto
    Go To    ${url}
