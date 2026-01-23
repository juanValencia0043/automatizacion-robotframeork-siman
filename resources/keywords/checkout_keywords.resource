*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Resource    ../../resources/keywords/general_keywords.resource
Resource    ../../resources/locators/checkout_locators.resource
Resource    ../../resources/variables/testdata.resource

*** Keywords ***
Login Checkout
    [Arguments]    ${user_type}
    [Documentation]    Metodo general para logearse en checkout ya sea como usuario recurrente o no 
    VAR    ${OTP}    
    
    Click Element By Type   ${BTN_GO_PAYMENT}    button

    # Espera específica para el campo de email
    Wait Until Element Is Visible    ${INPUT_NAME}    30s
    Wait Until Element Is Enabled    ${INPUT_NAME}    10s
    
    IF    '${user_type}' == 'guest_user'
        ${random_email}    Create Random Email
        Fill Element By Text    ${INPUT_EMAIL}    ${random_email}
        Click Element By Type    ${INPUT_NAME}    other
        Fill Element By Text    ${INPUT_NAME}    ${NAME}
        Fill Element By Text    ${INPUT_LAST_NAME}    ${LAST_NAME}
        Select List Item    ${SELECT_DOCUMENT}    ${DUI}
        Fill Element By Text    ${INPUT_DOCUMENT}     ${DOCUMENT}
        Fill Element By Text    ${INPUT_PHONE}    ${PHONE}
        Click Element By Type    ${CHECK_PRIVACY_TERMS}    checkbox
        Click Element By Type   ${BTN_GO_SHIPPING}    button        
    ELSE IF    '${user_type}' == 'new_user'
        ${random_email}    Create Random Email
        Fill Element By Text    ${INPUT_EMAIL}    ${random_email}
        Click Element By Type    ${INPUT_NAME}    other
        Fill Element By Text    ${INPUT_NAME}    ${NAME}
        Fill Element By Text    ${INPUT_LAST_NAME}    ${LAST_NAME}
        Select List Item    ${SELECT_DOCUMENT}    ${DUI}
        Fill Element By Text    ${INPUT_DOCUMENT}     ${DOCUMENT}
        Fill Element By Text    ${INPUT_PHONE}    ${PHONE}
        Click Element By Type    ${CHECK_SAVE_DATA}    checkbox
        Click Element By Type    ${CHECK_PRIVACY_TERMS}    checkbox
        Click Element By Type   ${BTN_GO_SHIPPING}    button   
        Wait Until Element Is Visible   ${BTN_SEND_EMAIL_CODE}    10s
        Click Element By Type   ${BTN_SEND_EMAIL_CODE}    button
        Wait Until Element Is Visible  ${BTN_CONFIRM_EMAIL_CODE}    10s
        Click Element By Type   ${BTN_CONFIRM_EMAIL_CODE}    button
        ${OTP}=    Login mail7   ${random_email}
        Fill Element By Text    ${INPUT_EMAIL_CODE}    ${OTP}
        Click Element By Type   ${BTN_CONFIRM_LOGIN}    button
    ELSE IF    '${user_type}' == 'recurrent_user'
        Fill Element By Text    ${INPUT_EMAIL}    ${EMAIL_RECURRENT}
        Click Element By Type    ${INPUT_NAME}    other
        Wait Until Element Is Visible   ${BTN_SEND_EMAIL_CODE}    10s
        Click Element By Type   ${BTN_SEND_EMAIL_CODE}    button
        Wait Until Element Is Visible  ${BTN_CONFIRM_EMAIL_CODE}    10s
        Click Element By Type   ${BTN_CONFIRM_EMAIL_CODE}    button
        ${OTP}=    Login mail7   ${EMAIL_RECURRENT}
        Fill Element By Text    ${INPUT_EMAIL_CODE}    ${OTP}
        Click Element By Type   ${BTN_CONFIRM_LOGIN}    button
    END

Create New Adress In Checkout
    [Arguments]    ${user_type}    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}
    [Documentation]    Metodo para crear una nueva direccion en el checkout

    # Espera específica para el campo de email
    Wait Until Element Is Visible    ${SELECT_DEPARMENT}    30s
    Wait Until Element Is Enabled    ${SELECT_DEPARMENT}    10s 

    IF    '${user_type}' == 'new_user'
        Select List Item    ${SELECT_DEPARMENT}    ${DEPARTMENT}
        Select List Item    ${SELECT_CITY}    ${CITY}
        Select List Item    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
        Fill Element By Text    ${INPUT_STREET}    Test Street
        Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
        Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
        Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    10s
        Click Element By Type    ${BTN_GO_TO_STEP3_PAYMENT}    button
    ELSE IF   '${user_type}' == 'recurrent_user'
        Click Element By Type    ${BTN_NEW_ADDRESS_OPTION}    button
        Select List Item    ${SELECT_DEPARMENT}    ${DEPARTMENT}
        Select List Item    ${SELECT_CITY}    ${CITY}
        Select List Item    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
        Fill Element By Text    ${INPUT_STREET}    Test Street
        Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
        Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
        Wait Until Element Is Visible    ${BTN_GO_TO_STEP3_PAYMENT}    10s
        Click Element By Type    ${BTN_GO_TO_STEP3_PAYMENT}    button
    END

Select Pickup Point
    [Arguments]    ${store_name}
    [Documentation]    Selecciona un punto de recogida por nombre de tienda
    
    Wait Until Element Is Visible    css=.vtex-pickup-points-modal-3-x-pointsList    15s
    
    # Buscar y hacer click en el elemento que contiene el nombre de la tienda
    Click Element    xpath=//p[contains(@class, 'pickupPointName') and contains(text(), '${store_name}')]/ancestor::div[contains(@class, 'pointsItem')]
    
    # Esperar a que se active el botón de confirmar
    Wait Until Element Is Visible    xpath=//button[text()='Recogida en este punto']    15s
    Click Element    xpath=//button[text()='Recogida en este punto']
    
    # Verificar que el modal se cerró
    Wait Until Element Is Not Visible    xpath=//button[text()='Recogida en este punto']    10s

Select Split Delivery
    [Arguments]    ${user_type}    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
    [Documentation]    Método para seleccionar la opción de delivery y pickup en checkout con esperas dinámicas

    # Espera para el campo de departamento
    #Log To Console    Seleccionando opción de Split Delivery con pickup point: ${PICKUP_NAME}

    IF    '${user_type}' == 'guest_user' or '${user_type}' == 'new_user'
        # Espera para el campo de departamento
        Wait Until Element Is Visible    ${SELECT_DEPARMENT}    30s
        Wait Until Element Is Enabled    ${SELECT_DEPARMENT}    10s 
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
        
    ELSE IF   '${user_type}' == 'recurrent_user'
        Wait Until Element Is Visible    ${BTN_EDIT_SHIPPING}    10s
        Wait Until Keyword Succeeds    3x    1s    
        ...    Click Element By Type    ${BTN_EDIT_SHIPPING}    link    
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
    ELSE IF    '${user_type}' == 'guest_user' or '${user_type}' == 'new_user' and '${PICKUP_NAME}' == 'Motocity'
        # Seleccionar el punto de recogida
        Select Split Method    ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    'Florely'    
    END

Select Split Method
    [Arguments]       ${DEPARTMENT}    ${CITY}    ${NEIGHBORHOOD}    ${PICKUP_NAME}
    [Documentation]    Método para seleccionar la opción de delivery y pickup en checkout con esperas dinámicas
        Wait Until Keyword Succeeds    25s    2s
        ...    Click Element By Type    ${BTN_SHIPPING_PICKUP}    button
        IF    '${PICKUP_NAME}' == 'Motocity'
            ${PICKUP_NAME}=    Set Variable    Florely
        ELSE
                    # Esperar a que aparezca el botón de buscar pickups disponibles
            TRY
                Wait Until Keyword Succeeds    15s    2s
                ...    Element Should Be Visible    ${FIND_PICKP_AVAIBLES}
                
                Wait Until Keyword Succeeds    10s    1s
                ...    Click Element By Type    ${FIND_PICKP_AVAIBLES}    button
            EXCEPT
                    Wait Until Keyword Succeeds    15s    2s
                    ...    Element Should Be Visible    ${CHANGE_PICKUP_BUTTON} 
                    
                    Wait Until Keyword Succeeds    10s    1s
                    ...    Click Element By Type    ${CHANGE_PICKUP_BUTTON}     button
            END
        END

        
        # Esperar a que cargue el modal de pickup points
        Wait Until Keyword Succeeds    3x    5s
        ...    Element Should Be Enabled    id:controls-wrapper
        
        # Seleccionar el punto de recogida
        Select Pickup Point    ${PICKUP_NAME}
        
        # Esperar a que se cierre el modal y aparezca el botón de continuar
        TRY
            Wait Until Keyword Succeeds    15s    2s
            ...    Element Should Be Visible    ${BTN_GO_TO_FILL_ADDRESS}
        
            Click Element By Type    ${BTN_GO_TO_FILL_ADDRESS}    button
        
            # Llenar información de dirección
            Wait Until Keyword Succeeds    10s    2s
            ...    Select List Item    ${SELECT_DEPARMENT}    ${DEPARTMENT}
            
            Wait Until Keyword Succeeds    10s    2s
            ...    Select List Item    ${SELECT_CITY}    ${CITY}
            
            Wait Until Keyword Succeeds    10s    2s
            ...    Select List Item    ${SELECT_NEIGHBORHOOD}    ${NEIGHBORHOOD}
            
            Fill Element By Text    ${INPUT_STREET}    Test Street
            Fill Element By Text    ${INPUT_COMPLEMENT}    Apto 123
            Fill Element By Text    ${INPUT_RECEIVER_NAME}    User Test
            # Finalizar y continuar a pago
            Wait Until Keyword Succeeds    15s    2s
            ...    Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
        EXCEPT
            #Log To Console    El botón de continuar a dirección no apareció, procediendo con dirección guardada.
            # Finalizar y continuar a pago
            Wait Until Keyword Succeeds    15s    2s
            ...    Click Element By Type    ${BTN_GO_PAYMENT_SHIPPING}    button
        END  



Select Payment Method
    [Arguments]    ${payment_method}
    [Documentation]    Selección de método de pago en checkout


    IF    '${payment_method}' == 'credisiman'
        # Lógica para seleccionar tarjeta de crédito
        Click Element By Type    ${paymentgroupcustomPrivate3Locator}    button
        Sleep   5s

    ELSE IF    '${payment_method}' == 'credisiman cuotas'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman cuotas

    ELSE IF   '${payment_method}' == 'credisiman cuotas intereses'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con credisiman cuotas intereses

    ELSE IF    '${payment_method}' == 'credisiman visa'
        # Lógica para seleccionar PayPal
        Log To Console    Seleccionando pago con credisiman visa

    ELSE IF   '${payment_method}' == 'tarjeta credito debito'
        # Lógica para seleccionar transferencia bancaria
        Log To Console    Seleccionando pago con tarjeta credito debito
    ELSE IF    '${payment_method}' == 'transferencia_bancaria'
        Wait Until Element Is Visible    ${PAYMENT_TRANS_BANK}    30s
        Wait Until Element Is Enabled    ${PAYMENT_TRANS_BANK}    10s
        Click Element By Type    ${paymentgroupcustomPrivate3Locator}    button
        Click Element By Type    ${PAYMENT_TRANS_BANK}    button
    END

Click Payment Submit Button
    [Documentation]    Click en el boton de finalizar compra en el checkout
    Wait Until Element Is Visible    ${BTN_CONFIRM_PURCHASE}    30s
    Wait Until Element Is Enabled    ${BTN_CONFIRM_PURCHASE}    10s
    Click Element By Type    ${BTN_CONFIRM_PURCHASE}    button


## ---- Finalizar compra ---- ##
## ---- Se refactorizará este keyword para incluir la verificación de orden ---- ##
Finish Purchase
    [Arguments]    ${verify_orden}
    [Documentation]    Finaliza la compra en el checkout

    IF    '${verify_orden}' == 'verify'

        Click Payment Submit Button

        # Realizar login en VTEX para verificar la orden
        Login Vtex    juan_valencia@siman.com

        # Esperar a que aparezca el card completo
        Wait Until Element Is Visible    xpath=//div[contains(., 'Vendido y entregado por')]    30s
        
        # Extraer texto completo
        ${FULL_TEXT}=    Get Text    xpath=//div[contains(., 'Orden #')]
        
        # Extraer Orden # (números después de "Orden #")
        ${ORDER_NUMBER}=    Get Regexp Matches    ${FULL_TEXT}    Orden #(\\d+)    1
        ${ORDER_NUMBER}=    Get From List    ${ORDER_NUMBER}    0
        
        # Extraer fecha (formato d/m/yyyy)
        ${ORDER_DATE}=    Get Regexp Matches    ${FULL_TEXT}    (\\d{1,2}/\\d{1,2}/\\d{4})    1
        ${ORDER_DATE}=    Get From List    ${ORDER_DATE}    0
        
        # Extraer email (patrón: texto@dominio.com)
        ${ORDER_EMAIL}=    Get Regexp Matches    ${FULL_TEXT}    ([\\w.-]+@[\\w.-]+\\.\\w+)    1
        ${ORDER_EMAIL}=    Get From List    ${ORDER_EMAIL}    0
        
        Log To Console    ***\n Información de la Orden ***
        Log To Console    Orden #${ORDER_NUMBER}
        Log To Console    Fecha: ${ORDER_DATE}
        Log To Console    Email: ${ORDER_EMAIL}

    ELSE IF    '${verify_orden}' == 'no_verify'
        
        Click Payment Submit Button

        # Solo se valida que la el login de vtex sea visible
        Wait Until Element Is Visible    ${INPUT_VTEX_LOGIN}    60s
        Log To Console    Compra finalizada sin verificación de orden
    END

