*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary
Resource    ../../resources/variables/environment.resource



*** Keywords ***
Disable SSL Warnings
    [Documentation]    Desactiva los warnings de SSL de urllib3
    Evaluate    __import__('urllib3').disable_warnings(__import__('urllib3').exceptions.InsecureRequestWarning)

Obtener Codigo OTP Mailsac
    [Arguments]    ${email_address}    ${max_reintentos}=36    ${tiempo_espera}=5s
    [Documentation]    Obtiene el código OTP del correo en Mailsac
    ...    Reintentos automáticos si no encuentra el correo o código OTP válido
    ...    Argumentos:
    ...    - email_address: Dirección de correo de Mailsac
    ...    - max_reintentos: Número máximo de reintentos (default: 3)
    ...    - tiempo_espera: Tiempo a esperar entre intentos (default: 60s)
    
    ${headers}=    Create Dictionary    Mailsac-Key=${MAILSAC_API_KEY}    Mailsac-Host=${MAILSAC_HOST}
    ${intentos}=    Set Variable    0
    #    [DEBUG]    setear email vacío fijo para pruebas
    #    ${email_address}=    Set Variable    new_mail_siman@mailsac.com    

    FOR    ${intentos}    IN RANGE    ${max_reintentos}
        Log To Console    Intento número: ${intentos + 1}
        Disable SSL Warnings
        Create Session    mailsac    ${MAILSAC_BASE_URL}    headers=${headers}
        ${response}=    GET On Session    mailsac    /addresses/${email_address}/messages
        Status Should Be    200    ${response}
        #    [DEBUG]    
        #    Log To Console    Respuesta de mensajes: ${response.text}
        IF    ${response.json()}==[]
            IF    ${intentos + 1} == ${max_reintentos}
                Fail    No se encontraron correos después de ${max_reintentos} intentos.
            ELSE
                Log To Console    No se encontraron correos. Esperando ${tiempo_espera} antes del siguiente intento...
                Sleep    ${tiempo_espera} 
                CONTINUE
            END
        ELSE
            Log To Console    Correos encontrados. Procesando el último mensaje...
            Exit For Loop
        END
    END    
    ${messages}=    Set Variable    ${response.json()}
    ${latest_message}=    Get From List    ${messages}    0
    ${message_id}=    Get From Dictionary    ${latest_message}    _id
    Log To Console    ID del último mensaje: ${message_id}
    #    Obtener el contenido del correo
    ${body_res}=    GET On Session    mailsac    /text/${email_address}/${message_id}
    Status Should Be    200    ${body_res}
    ${otp}=    Get Lines Matching Regexp    ${body_res.text}    \\d{6}
    Log To Console    Código OTP obtenido: ${otp}
    RETURN    ${otp}


    

