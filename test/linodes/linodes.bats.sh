#!/usr/bin/env bats

load '../test_helper/bats-support/load'
load '../test_helper/bats-assert/load'
load '../common'

@test "it should create linodes with a label" {
    run linode-cli linodes create --type g6-standard-2 --region us-east --image linode/debian9 --label cli-1 --root_pass badDSFS8942 --text --delimiter "," --no-headers
    assert_output --regexp '.*,cli-1,us-east,g6-standard-2,linode\/debian9,.*'
}

@test "it should view the linode configuration" {
    linode_id="$(linode-cli --text --no-headers linodes list | awk '{ print $1 }' | xargs)"
    run linode-cli linodes view "$linode_id" --text --delimiter "," --no-headers
    assert_output --regexp "$linode_id,cli-1,us-east,g6-standard-2,linode\/debian9,.*"
}

@test "it should create a linode with the minimum required props" {
    run linode-cli linodes create --type g6-standard-2 --region us-east --root_pass badDSFS8942
    [ "$status" -eq 0 ]
}


# ONLY WORKS BECAUSE I HAVE A .linode-cli
@test "it should fail to create a linode without a root_pass" {
    run linode-cli linodes create --type g6-standard-2 --region us-east
    [ "$status" -eq 1 ]
}

@test "it should list linodes" {
    run bash -c "linode-cli --text --no-headers linodes list | grep cli-1"
    [ "$status" -eq 0 ]
}

@test "it should remove all linodes" {
    run removeLinodes
}