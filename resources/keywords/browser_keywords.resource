*** Settings ***
Library     SeleniumLibrary
Resource    ../../resources/variables/checkout_urls.resource
Resource    ../../resources/variables/environment.resource


*** Keywords ***
Open Browser To Checkout
    [Documentation]    Abre checkout según el environment (prod o sandbox)
    [Arguments]    ${cart_type}

    # Determinar las URLs basado en el environment
    ${checkout_url}=    Set Variable If
    # PRODUCCIÓN
    ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'small'    ${CHECKOUT_PROD_SMALL}
    ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'small_mk'    ${CHECKOUT_PROD_SMALL_MK}
    ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'big'    ${CHECKOUT_PROD_BIG}
    ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'split_siman'    ${CHECKOUT_PROD_SPLIT_SIMAN}
    ...    '${ENVIRONMENT}' == 'prod' and '${cart_type}' == 'split_siman_mk'    ${CHECKOUT_PROD_SPLIT_SIMAN_MK}
    # SANDBOX
    ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'small'    ${CHECKOUT_SANDBOX_SMALL}
    ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'small_mk'    ${CHECKOUT_SANDBOX_SMALL_MK}
    ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'big'    ${CHECKOUT_SANDBOX_BIG}
    ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_siman'    ${CHECKOUT_SANDBOX_SPLIT_SIMAN}
    ...    '${ENVIRONMENT}' == 'sandbox' and '${cart_type}' == 'split_siman_mk'    ${CHECKOUT_SANDBOX_SPLIT_SIMAN_MK}
    # DEFAULT (fallback)
    ...    ${CHECKOUT_PROD_SMALL}

    Open Browser With Options    ${checkout_url}
    Sleep    2s

Open Browser With Options
    [Documentation]    Abre navegador con opciones configuradas (Headless solo en CI)
    [Arguments]    ${url}

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

    # HEADLESS SOLO EN CI/CD
    IF    '${CI}' == 'true'
        Call Method    ${options}    add_argument    --headless=new
    END

    # Opciones comunes (local + CI)
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage

    Open Browser    ${url}    ${BROWSER}    options=${options}
