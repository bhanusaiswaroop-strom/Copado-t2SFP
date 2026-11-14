@echo off
setlocal EnableExtensions EnableDelayedExpansion
REM Local Agentia quality gates (Windows).

echo ## Running Apex Test Checks
if not "%AGENTIA_APEX_TEST_CLASSES%"=="" (
    agentia cicd work test apex -t "%AGENTIA_APEX_TEST_CLASSES%" %AGENTIA_APEX_RERUN_FAILED%
) else (
    echo Skipping Apex CLI run: no classes specified.
)
if errorlevel 1 exit /b %errorlevel%

echo ## Running LWC tests
call npx sfdx-lwc-jest -- --passWithNoTests
if errorlevel 1 exit /b %errorlevel%
