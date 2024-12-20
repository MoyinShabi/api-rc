fltbuild:
	del pubspec.lock && flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs

fpg:
	flutter pub get

brb:
	dart run build_runner build --delete-conflicting-outputs

brw:
	dart run build_runner watch --delete-conflicting-outputs

fgl:
	flutter gen-l10n

gpom:
	git pull origin main

rue:
	Remove-Item -Recurse -Force .\.dart_tool\build; Get-ChildItem -Path . -Recurse -Filter *.*.dart | Remove-Item -Force; dart run build_runner build --delete-conflicting-outputs

testcov:
	flutter test --coverage

lcov: testcov
	perl $(GENHTML) -o coverage\html coverage\lcov.info