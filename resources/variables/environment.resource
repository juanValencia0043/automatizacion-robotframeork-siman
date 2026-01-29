*** Variables ***
${TIMEOUT}              10s
${BROWSER}              chrome              # Default - overridden by run_tests.py
${BASE_URL}             https://localhost   # Default - overridden by run_tests.py
${INCOGNITO_MODE}       ${True}
${ENVIRONMENT}          sandbox             # Default - overridden by run_tests.py
${HEADLESS}             ${False}            # Default - overridden by run_tests.py
${EXECUTION_DIR}        results/executions  # Default - overridden by run_tests.py
${SCREENSHOT_DIR}       results/screenshots    # Default - overridden by run_tests.py
${CI}                   %{CI=false}
${MAILSAC_API_KEY}      k_7oLKTfcJ6JmlzL4McVbdhWvYGYm2MkFGB1Nvlqg6DLQ406d
${MAILSAC_HOST}         mailsac.com
${MAILSAC_BASE_URL}     https://mailsac.com/api