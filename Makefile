JEKYLL = jekyll

.PHONY: serve
serve: serve-dev

.PHONY: serve-prod
serve-prod:
	rm -rf _site
	$(JEKYLL) serve --config=_config.yml

.PHONY: serve-dev
serve-dev:
	rm -rf _site
	$(JEKYLL) serve --config=_config.yml,_config_dev.yml

.PHONY: all
all: _admin/new-draft _admin/publish

_admin/new-draft: _admin/new-draft.sh
	shtk build -o $@ $<

_admin/publish: _admin/publish.sh
	shtk build -o $@ $<
