all: _admin/publish

_admin/publish: _admin/publish.sh
	shtk build -o $@ $<
