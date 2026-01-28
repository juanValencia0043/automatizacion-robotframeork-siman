*** Settings ***
Library     SeleniumLibrary
Library     DateTime
Library     String
Resource    ../../resources/locators/login_vtex_locators.resource
Resource    ../../resources/locators/general_locators.resource


*** Keywords ***
Click Element By Type
    [Documentation]    Click especializado por tipo de elemento
    [Arguments]    ${element_identifier}    ${element_type}=button

    Page Should Contain Element    ${element_identifier}

    # Estrategias específicas por tipo
    IF    '${element_type}' == 'button'
        Click Button Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'link'
        Click Link Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'checkbox'
        Click Checkbox Safe    ${element_identifier}
    ELSE IF    '${element_type}' == 'radio'
        Click Radio Button Safe    ${element_identifier}
    ELSE
        Click Element    ${element_identifier}
    END

Click Button Safe
    [Documentation]    Click especializado para botones con esperas robustas
    [Arguments]    ${link_identifier}
    Wait Until Element Is Visible    ${link_identifier}    30s
    Wait Until Element Is Enabled    ${link_identifier}    30s
    Click Element    ${link_identifier}

Click Link Safe
    [Documentation]    Click especializado para enlaces con esperas robustas
    [Arguments]    ${link_identifier}
    Wait Until Element Is Visible    ${link_identifier}    30s
    Wait Until Element Is Enabled    ${link_identifier}    30s
    Scroll Element Into View    ${link_identifier}
    Click Link    ${link_identifier}

Click Checkbox Safe
    [Documentation]    Click especializado para checkboxes con esperas robustas
    [Arguments]    ${checkbox_identifier}
    Wait Until Element Is Visible    ${checkbox_identifier}    30s
    Wait Until Element Is Enabled    ${checkbox_identifier}    30s
    Select Checkbox    ${checkbox_identifier}

Click Radio Button Safe
    [Documentation]    Click especializado para radio buttons con esperas robustas
    [Arguments]    ${radio_identifier}
    Wait Until Element Is Visible    ${radio_identifier}    30s
    Click Element    ${radio_identifier}

Fill Element By Text
    [Documentation]    Llenado robusto de campos de texto con manejo de errores
    ...    - Esperas inteligentes
    ...    - Validación de parámetros
    ...    - Captura de errores detallada
    ...    - Screenshots en caso de error
    [Arguments]    ${element_identifier}    ${text_element}="${EMPTY}"

    # Validar parámetros obligatorios
    IF    '${element_identifier}' == '${EMPTY}'
        Fail    msg=El identificador del elemento no puede estar vacío
    END

    TRY
        # Espera inteligente para el elemento
        Wait Until Keyword Succeeds    3x    2s
        ...    Page Should Contain Element    ${element_identifier}

        # Esperar a que sea visible e interactuable
        Wait Until Keyword Succeeds    3x    1s
        ...    Element Should Be Visible    ${element_identifier}

        Wait Until Keyword Succeeds    2x    1s
        ...    Element Should Be Enabled    ${element_identifier}

        # Limpiar campo antes de escribir (opcional)
        Clear Element Text    ${element_identifier}

        # Solo escribir si hay texto proporcionado
        IF    '${text_element}' != '${EMPTY}'
            Input Text    ${element_identifier}    ${text_element}

            Log    Campo ${element_identifier} llenado con: ${text_element}
        ELSE
            Log    Campo ${element_identifier} se dejó vacío como se solicitó
        END
    EXCEPT    AS    ${error_message}
        # Capturar screenshot en caso de error
        Capture Page Screenshot    error_fill_{$element_identifier}.png

        # Log detallado del error
        Log    Error al llenar campo ${element_identifier}: ${error_message}    level=ERROR
        Log    Texto intentado: ${text_element}    level=DEBUG

        # Fallar con mensaje descriptivo
        Fail
        ...    No se pudo llenar el campo '${element_identifier}' con el texto '${text_element}'. Error: ${error_message}
    END

Select List Item
    [Documentation]    Selecciona un item de lista con validaciones robustas
    ...    - Validación de parámetros
    ...    - Esperas inteligentes con reintentos
    ...    - Manejo de listas desplegables dinámicas
    ...    - Verificación de selección múltiple
    ...    - Captura de errores con screenshots
    [Arguments]    ${locator}    ${label}

    # Validar parámetros obligatorios
    IF    '${locator}' == '${EMPTY}'
        Fail    msg=El locator de la lista no puede estar vacío
    END

    IF    '${label}' == '${EMPTY}'
        Fail    msg=El label a seleccionar no puede estar vacío
    END

    TRY
        # Espera robusta para que la lista esté lista
        Wait Until Keyword Succeeds    3x    2s
        ...    Page Should Contain Element    ${locator}

        Wait Until Keyword Succeeds    3x    2s
        ...    Element Should Be Visible    ${locator}

        Wait Until Keyword Succeeds    3x    1s
        ...    Element Should Be Enabled    ${locator}

        # Verificar que la lista tiene opciones
        Wait Until Keyword Succeeds    2x    2s
        ...    List Selection Should Be Possible    ${locator}

        # Seleccionar por label con manejo de error específico
        Wait Until Keyword Succeeds    2x    1s
        ...    Select From List By Label    ${locator}    ${label}

        # Verificación robusta de la selección
        Wait Until Keyword Succeeds    3x    1s
        ...    Verify List Selection    ${locator}    ${label}
    EXCEPT    AS    ${error_message}
        # Capturar screenshot y información de debug
        Capture Page Screenshot    error_select_list_{$locator}.png

        # Obtener información de debug
        ${available_labels}=    Run Keyword And Ignore Error
        ...    Get List Items    ${locator}

        ${current_selection}=    Run Keyword And Ignore Error
        ...    Get Selected List Label    ${locator}

        # Log detallado del error
        Log    Error al seleccionar '${label}' en ${locator}: ${error_message}    level=ERROR
        IF    '${available_labels}[0]' == 'PASS'
            Log    Opciones disponibles: ${available_labels}[1]    level=DEBUG
        END
        IF    '${current_selection}[0]' == 'PASS'
            Log    Selección actual: ${current_selection}[1]    level=DEBUG
        END

        # Re-lanzar error con mensaje mejorado
        Fail    No se pudo seleccionar '${label}' en la lista '${locator}'. Error: ${error_message}
    END

Verify List Selection
    [Documentation]    Keyword auxiliar para verificar la selección
    [Arguments]    ${locator}    ${expected_label}

    ${selected_label}=    Get Selected List Label    ${locator}
    Should Be Equal As Strings    ${selected_label}    ${expected_label}
    ...    msg=La selección no coincide. Esperado: '${expected_label}' - Actual: '${selected_label}'

List Selection Should Be Possible
    [Documentation]    Verifica que la lista tenga opciones disponibles
    [Arguments]    ${locator}

    ${items}=    Get List Items    ${locator}
    Should Not Be Empty    ${items}
    ...    msg=La lista ${locator} no tiene opciones disponibles

Create Random Email
    [Documentation]    Generador de email para usuario nuevo
    ...    Formato: timestamp+test+@yopmail.com
    ...    Ejemplo: 20241215123045_test@yopmail.com

    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${random_email}=    Catenate    SEPARATOR=${EMPTY}    ${timestamp}    _test    @yopmail.com
    RETURN    ${random_email}

Login Yopmail
    [Documentation]    Obtiene el código OTP enviado a Yopmail
    [Arguments]    ${email}

    ${BANDERA}=    Set Variable    True
    @{window_handles}=    Get Window Handles
    ${TAB_ORIGINAL}=    Set Variable    ${window_handles}[0]

    # Abrir pagina yopmail en una nueva pestaña y obtener token
    Execute Javascript    window.open("${YOPMAIL_URL}", "_blank")
    Switch Window    NEW

    Fill Element By Text    ${INPUT_YOPMAIL}    ${email}
    Click Element By Type    ${BTN_CHECK_YOPMAIL}    button

    #    Esperar hasta recibir el correo con el token
    WHILE    ${BANDERA}
        Sleep    5s

        # Siempre despegar el frame antes de entrar
        #Log To Console    \n--- Despejando frame antes de entrar ---\n
        Unselect Frame

        Select Frame    xpath=//*[@id="ifmail"]
        #Log To Console    \n--- Frame seleccionado ---\n

        TRY
            #Log To Console    \n--- Intentando obtener OTP ---\n
            ${OTP}=     Get OTP From Mail
            #${OTP}=    Get Text    xpath=//*[@id="mail"]/div/div[2]/table/tbody/tr/td/table/tbody/tr/td/div/p[2]
            
            IF    '${OTP}' != ''
                ${BANDERA}=    Set Variable    False
                Unselect Frame
            ELSE
                Unselect Frame
                Click Element By Type    ${BTN_REFRESH_YOPMAIL}    button
            END
        EXCEPT
            Unselect Frame
            Click Element By Type    ${BTN_REFRESH_YOPMAIL}    button
        END
    END

    # Eliminar correo para futuras pruebas
    Wait Until Element Is Enabled    ${FRAME_MAILS_LIST}    30s
    Select Frame    ${FRAME_MAILS_LIST}
    Click Element By Type    ${EMAIL_CHECKBOX_YOPMAIL}    checkbox
    Unselect Frame

    Click Element By Type    ${BTN_DELETE_YOPMAIL}    button

    Sleep    5s

    # Regresar a la pestaña original
    Close Window
    Switch Window    ${TAB_ORIGINAL}
    RETURN    ${OTP}


Login Yopmail Vtex
    [Documentation]    Obtiene el código OTP enviado a Yopmail
    ...    para el email

    ${BANDERA}=    Set Variable    True
    @{window_handles}=    Get Window Handles
    ${TAB_ORIGINAL}=    Set Variable    ${window_handles}[0]

    # Abrir pagina yopmail en una nueva pestaña y obtener token
    Execute Javascript    window.open("https://www.yopmail.com/es/", "_blank")
    Switch Window    NEW

    Fill Element By Text    ${INPUT_YOPMAIL}    tokens_siman_automatizacion
    Click Element By Type    ${BTN_CHECK_YOPMAIL}    button

    #    Esperar hasta recibir el correo con el token
    WHILE    ${BANDERA}
        Sleep    5s

        # Siempre despegar el frame antes de entrar
        Unselect Frame

        Select Frame    xpath=//*[@id="ifmail"]

        TRY
            ${OTP}=    Get Text    xpath=//*[@id="mail"]/div/div[2]/table/tbody/tr/td/table/tbody/tr/td/div/p[2]
            IF    '${OTP}' != ''
                ${BANDERA}=    Set Variable    False
                Unselect Frame
            ELSE
                Unselect Frame
                Click Element By Type    ${BTN_REFRESH_YOPMAIL}    button
            END
        EXCEPT
            Unselect Frame
            Click Element By Type    ${BTN_REFRESH_YOPMAIL}    button
        END
    END

    # Eliminar correo para futuras pruebas
    Wait Until Element Is Enabled    ${FRAME_MAILS_LIST}    30s
    Select Frame    ${FRAME_MAILS_LIST}
    Click Element By Type    ${EMAIL_CHECKBOX_YOPMAIL}    checkbox
    Unselect Frame

    Click Element By Type    ${BTN_DELETE_YOPMAIL}    button

    Sleep    5s

    # Regresar a la pestaña original
    Close Window
    Switch Window    ${TAB_ORIGINAL}
    RETURN    ${OTP}

Get mail 
    [Documentation]    Obtiene el correo temporal de Yopmail
    
    #Log To Console   \n--- Obteniendo correo yopmail ---\n
    ${MAIL_TEXT}=    Get Text    ${YOPMAIL_MAIL_FRAME}
    #Log To Console     ${MAIL_TEXT}
    RETURN    ${MAIL_TEXT}

Get OTP From Mail
    [Documentation]    Extrae el código OTP (6 dígitos) del texto del correo usando regex

    VAR    ${mail_text}
    # Busca un patrón de 6 dígitos consecutivos en el texto
    ${otp}=    Get Regexp Matches    ${mail_text}    \\d{6}    
    
    # Si se encontraron coincidencias, devolver la primera
    IF    ${otp}
        RETURN    ${otp}[0]
    ELSE
        Fail    No se encontró código OTP (6 dígitos) en el texto del correo
    END

Login Vtex
    [Documentation]    Realiza login en plataforma VTEX
    [Arguments]    ${email}

    Wait Until Element Is Visible    ${INPUT_VTEX_LOGIN}    30s
    Fill Element By Text    ${INPUT_VTEX_LOGIN}    ${email}
    Click Element By Type    ${BTN_CONTINUE_VTEX_LOGIN}    button

    # Obtener código OTP desde Yopmail
    ${OTP}=    Login Yopmail Vtex

    Wait Until Element Is Visible    ${INPUT_VTEX_TOKEN}    30s
    Fill Element By Text    ${INPUT_VTEX_TOKEN}    ${OTP}
    Click Element By Type    ${BTN_SUBMIT_VTEX_LOGIN}    button

Login Vtex with Google
    [Documentation]    Realiza login en plataforma VTEX con contraseña
    [Arguments]    ${email}    ${password}
    
    Wait Until Element Is Visible    ${INPUT_VTEX_LOGIN}    30s
    Fill Element By Text    ${INPUT_VTEX_LOGIN}    ${email}
    Click Element By Type    ${BTN_CONTINUE_VTEX_LOGIN}    button