@echo off
echo ===================================================
echo Building Skin Disease Analysis J2EE Project...
echo ===================================================

if not exist src\main\webapp\WEB-INF\classes mkdir src\main\webapp\WEB-INF\classes

javac -cp "src/main/webapp/WEB-INF/lib/*" -d src/main/webapp/WEB-INF/classes src/main/java/com/skindisease/db/*.java src/main/java/com/skindisease/model/*.java src/main/java/com/skindisease/servlet/*.java src/main/java/com/skindisease/tag/*.java

echo ===================================================
echo Build Successful! Compiled classes ready in WEB-INF/classes
echo ===================================================
pause
