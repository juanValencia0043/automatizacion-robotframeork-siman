*** Variables ***
${TIMEOUT}              10s
${BROWSER}              chrome              # Default - overridden by run_tests.py
${BASE_URL}             https://localhost   # Default - overridden by run_tests.py
${INCOGNITO_MODE}       ${True}
${ENVIRONMENT}          sandbox             # Default - overridden by run_tests.py
${HEADLESS}             ${False}            # Default - overridden by run_tests.py
${EXECUTION_DIR}        results/executions  # Default - overridden by run_tests.py
${SCREENSHOT_DIR}       results/screenshots # Default - overridden by run_tests.py
