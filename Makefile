SHELL := /bin/bash

build:
	cd optimizer && cargo build
	cd spawner && cargo build
	cd tick_parser && cargo build
	cd util && cargo build
	cd backtester && cargo build
	cd mm && npm install
	# TODO: Collect the results into a nice format

release:
	cd optimizer && cargo build --release
	cd spawner && cargo build --release
	cd tick_parser && cargo build --release
	cd util && cargo build --release
	cd backtester && cargo build --release
	cd mm && npm install
	# TODO: Collect the results into a nice format

clean:
	rm optimizer/target -rf
	rm spawner/target -rf

	for dir in ./strategies/*/; \
	do \
		rm $$dir/target -rf; \
	done

	rm tick_parser/target -rf
	rm util/target -rf
	rm dist -rf
	rm backtester/target -rf
	rm mm/node_modules -rf

test:
	cd optimizer && cargo test
	cd spawner && cargo test

	# Build each strategy
	for dir in ./strategies/*/; \
	do \
		cd $$dir && cargo test; \
	done

	cd tick_parser && cargo test
	cd util && cargo test
	cd backtester && cargo test
	cd mm && npm install
	# TODO: Collect the results into a nice format

bench:
	cd tick_parser && cargo bench
	cd util && cargo bench
	cd backtester && cargo bench
	for dir in ./strategies/*/; \
	do \
		cd $$dir && cargo bench; \
	done
	# TODO: Collect the results into a nice format

install:
	mkdir -p dist
	cp optimizer/target/release/optimizer dist
	cp ./mm dist -r
	cp spawner/target/release/spawner dist
	cp tick_parser/target/release/tick_processor dist
	cp backtester/target/release/backtester dist

update:
	cd optimizer && cargo update
	cd spawner && cargo update

	# Build each strategy
	for dir in ./strategies/*/; \
	do \
		cd $$dir && cargo update; \
	done

	cd tick_parser && cargo update
	cd util && cargo update
	cd backtester && cargo update
	cd mm && npm update

cdoc:
	cd optimizer && cargo rustdoc --open -- --no-defaults --passes collapse-docs --passes unindent-comments --passes strip-priv-imports
	cd spawner && cargo rustdoc --open -- --no-defaults --passes collapse-docs --passes unindent-comments --passes strip-priv-imports

	# Build each strategy
	for dir in ./strategies/*/; \
	do \
		cd $$dir && cargo rustdoc --open -- --no-defaults --passes collapse-docs --passes unindent-comments --passes strip-priv-imports; \
	done

	cd tick_parser && cargo rustdoc --open -- --no-defaults --passes collapse-docs --passes unindent-comments --passes strip-priv-imports
	cd util && cargo test
	cd backtester && cargo rustdoc --open -- --no-defaults --passes collapse-docs --passes unindent-comments --passes strip-priv-imports
	cd mm && npm install
	# TODO: Collect the results into a nice format

# kill off any straggler processes
kill:
	if [[ $$(ps -aux | grep '[t]arget/debug') ]]; then \
		kill $$(ps -aux | grep '[t]arget/debug' | awk '{print $$2}'); \
	fi
	if [[ $$(ps -aux | grep '[m]anager.js') ]]; then \
		kill $$(ps -aux | grep '[m]anager.js' | awk '{print $$2}'); \
	fi
