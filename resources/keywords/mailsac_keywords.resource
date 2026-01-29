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
    [Arguments]    ${email_address}    ${max_reintentos}=3    ${tiempo_espera}=5s
    [Documentation]    Obtiene el código OTP del correo en Mailsac
    ...    Reintentos automáticos si no encuentra el correo o código OTP válido
    ...    Argumentos:
    ...    - email_address: Dirección de correo de Mailsac
    ...    - max_reintentos: Número máximo de reintentos (default: 3)
    ...    - tiempo_espera: Tiempo a esperar entre intentos (default: 60s)
    
    ${max_reintentos_int}=    Evaluate    int(${max_reintentos})
    
    FOR    ${intento}    IN RANGE    1    ${max_reintentos_int + 1}
        TRY
            Log To Console    Intento ${intento}/${max_reintentos} para obtener el código OTP desde ${email_address}
            #    Esperar a que caiga el mail
            Sleep    ${tiempo_espera}
            #    Configurar headers
            ${headers}=    Create Dictionary    Mailsac-Key=${MAILSAC_API_KEY}    Mailsac-Host=${MAILSAC_HOST}
            Create Session    mailsac    ${MAILSAC_BASE_URL}    headers=${headers}    verify=False
            #    Obtener mensajes
            ${response}=    GET On Session    mailsac    /addresses/${email_address}/messages
            Status Should Be    200    ${response}
            
            #    Obtener respuesta JSON
            ${response_json}=    Set Variable    ${response.json()}
            
            #    Obtener ID del mensaje mas reciente (falla si la lista está vacía)
            ${LAST_MESSAGE}=    Evaluate    response_json[0]    response_json=${response_json}
            ${message_id}=    Set Variable    ${LAST_MESSAGE['_id']}
            Log    Mensaje encontrado con ID: ${message_id}
            
            #    Obtener contenido del mensaje
            ${body_res}=    Get On Session    mailsac    /text/${email_address}/${message_id}
            
            #    Extraer codigo OTP del contenido
            ${OTP}=    Get Lines Matching Regexp    ${body_res.text}    \\d{6}
            
            #    Obtener el primer código OTP (falla si la lista está vacía)
            ${OTP_CODE}=    Evaluate    otp[0]    otp=${OTP}
            
            Log    Código OTP obtenido exitosamente en el intento ${intento}: ${OTP_CODE}
            RETURN    ${OTP_CODE}
        EXCEPT    *    AS    ${error}
            Log    Intento ${intento}/${max_reintentos} fallido: ${error}    level=WARN
            
            IF    ${intento} >= ${max_reintentos}
                Fail    No se pudo obtener el código OTP después de ${max_reintentos} intentos. Último error: ${error}
            END
        END
    END

