# HID Utility

HID Utility

go clean -modcache
go mod tidy
go get ...
go run ./main.go

# Build

go build -o ../build/hid.exe -tags=release

go build -ldflags "-H windowsgui -s -w" -o ../build/hid.exe -tags=release
