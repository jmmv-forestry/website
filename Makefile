all: _admin/new-draft _admin/publish

_admin/new-draft: _admin/new-draft.sh
	shtk build -o $@ $<

_admin/publish: _admin/publish.sh
	shtk build -o $@ $<
