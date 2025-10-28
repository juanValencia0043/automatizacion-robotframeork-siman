*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Checkout
    [Arguments]     ${cart_type}  
    [Documentation]    Abre directamente a un carrito específico de producción
    
    ${checkout_url}=    Set Variable If
    ...    '${cart_type}' == 'small'              ${CHECKOUT_PROD_SMALL}
    ...    '${cart_type}' == 'small_mk'           ${CHECKOUT_PROD_SMALL_MK}
    ...    '${cart_type}' == 'big'                ${CHECKOUT_PROD_BIG}
    ...    '${cart_type}' == 'split_siman'        ${CHECKOUT_PROD_SPLIT_SIMAN}
    ...    '${cart_type}' == 'split_siman_mk'     ${CHECKOUT_PROD_SPLIT_SIMAN_MK} 

    Open Browser    ${checkout_url}    ${BROWSER}
    Maximize Browser Window

    Log To Console    ✅ Carrito ${cart_type} cargado: ${checkout_url}

Close Browser
    [Documentation]    Cierra el navegador
    Close Browser
