Feature: nmcli: connection

    # Please do use tags as follows:
    # @bugzilla_link (rhbz123456)
    # @version_control (ver+/-=1.4.1)
    # @other_tags (see environment.py)
    # @test_name (compiled from scenario name)
    # Scenario:

    @connection_help
    Scenario: nmcli - connection - help and autocompletion
    Then "COMMAND :=  { show | up | down | add | modify | edit | delete | reload | load }\s+show\s+up\s+down\s+add\s+modify\s+edit\s+edit\s+delete\s+reload\s+load" is visible with command "nmcli connection help"
    Then "--active" is visible with tab after "nmcli connection show "
    Then "autoconnect" is visible with tab after "nmcli connection add "
    Then "con-name" is visible with tab after "nmcli connection add "
    Then "help" is visible with tab after "nmcli connection add "
    Then "ifname" is visible with tab after "nmcli connection add "
    Then "type" is visible with tab after "nmcli connection add "
    Then "add" is visible with tab after "nmcli connection "
    Then "down" is visible with tab after "nmcli connection "
    Then "help" is visible with tab after "nmcli connection "
    Then "modify" is visible with tab after "nmcli connection "
    Then "show" is visible with tab after "nmcli connection "
    Then "delete" is visible with tab after "nmcli connection "
    Then "edit" is visible with tab after "nmcli connection "
    Then "load" is visible with tab after "nmcli connection "
    Then "reload" is visible with tab after "nmcli connection "
    Then "up" is visible with tab after "nmcli connection "
    Then "Usage: nmcli connection add { OPTIONS | help }\s+OPTIONS \:= COMMON_OPTIONS TYPE_SPECIFIC_OPTIONS IP_OPTIONS\s+COMMON_OPTIONS:\s+type <type>\s+ifname <interface name> |\s+ethernet\:\s+wifi:\s+ssid <SSID>\s+gsm:\s+apn <APN>\s+cdma:\s+infiniband:\s+bluetooth:\s+vlan:\s+dev <parent device \(connection  UUID, ifname, or MAC\)>\s+bond:\s+bond-slave:\s+master <master \(ifname or connection UUID\)>\s+team:\s+team-slave:\s+master <master \(ifname or connection UUID\)>\s+bridge:\s+bridge-slave:\s+master <master \(ifname or connection UUID\)>\svpn:\s+vpn-type vpnc|openvpn|pptp|openconnect|openswan\s+olpc-mesh:\s+ssid" is visible with command "nmcli connection add help"


    @con_con_remove
    @connection_names_autocompletion
    Scenario: nmcli - connection - names autocompletion
    Then "testeth0" is visible with tab after "nmcli connection edit id "
    Then "testeth6" is visible with tab after "nmcli connection edit id "
    Then "con_con" is not visible with tab after "nmcli connection edit id "
    * Add connection type "ethernet" named "con_con" for device "eth5"
    Then "con_con" is visible with tab after "nmcli connection edit "
    Then "con_con" is visible with tab after "nmcli connection edit id "


    @rhbz1375933
    @con_con_remove
    @device_autocompletion
    Scenario: nmcli - connection - device autocompletion
    Then "eth0|eth1|eth10" is visible with tab after "nmcli connection add type ethernet ifname "


    @rhbz1367736
    @con_con_remove
    @connection_objects_autocompletion
    Scenario: nmcli - connection - objects autocompletion
    Then "ipv4.dad-timeout" is visible with tab after "nmcli  connection add type bond -- ipv4.method manual ipv4.addresses 1.1.1.1/24 ip"


    @rhbz1301226
    @ver+=1.4.0
    @con_con_remove
    @802_1x_objects_autocompletion
    Scenario: nmcli - connection - 802_1x objects autocompletion
    * "802.1x" is visible with tab after "nmcli  connection add type ethernet ifname eth5 con-name con_con2 802-"
    * Add a new connection of type "ethernet" and options "ifname eth5 con-name con_con 802-1x.identity jdoe 802-1x.eap leap"
    Then "802-1x.eap:\s+leap\s+802-1x.identity:\s+jdoe" is visible with command "nmcli con show con_con"


    @rhbz1391170
    @ver+=1.8.0
    @connection_get_value
    Scenario: nmcli - connection - get value
    Then "testeth0\s+eth0" is visible with command "nmcli -g connection.id,connection.interface-name connection show testeth0"
     And "--" is visible with command "nmcli connection show testeth0 |grep connection.master"
     And "--" is not visible with command "nmcli -t connection show testeth0 |grep connection.master"


    @rhbz842975
    @connection_no_error
    Scenario: nmcli - connection - no error shown
    Then "error" is not visible with command "nmcli -f DEVICE connection"
    Then "error" is not visible with command "nmcli -f DEVICE dev"
    Then "error" is not visible with command "nmcli -f DEVICE nm"


    @con_con_remove
    @connection_delete_while_editing
    Scenario: nmcli - connection - delete opened connection
     * Add connection type "ethernet" named "con_con" for device "eth5"
     * Open editor for "con_con" with timeout
     * Delete connection "con_con" and hit Enter


    @rhbz1168657
    @con_con_remove
    @connection_double_delete
    Scenario: nmcli - connection - double delete
     * Add connection type "ethernet" named "con_con" for device "*"
     * Delete connection "con_con con_con"


    @rhbz1171751
    @teardown_testveth @con_con_remove
    @connection_profile_duplication
    Scenario: nmcli - connection - profile duplication
     * Prepare simulated test "testX" device
     * Add a new connection of type "ethernet" and options "ifname testX con-name con_con autoconnect no"
     * Execute "echo 'NM_CONTROLLED=no' >> /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Reload connections
     * Execute "rm -f /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Add a new connection of type "ethernet" and options "ifname eth5 con-name con_con autoconnect no"
     * Reload connections
     Then "1" is visible with command "nmcli c |grep con_con |wc -l"
     * Bring "up" connection "con_con"


    @rhbz1174164
    @add_testeth5
    @connection_veth_profile_duplication
    Scenario: nmcli - connection - veth - profile duplication
    * Connect device "eth5"
    * Connect device "eth5"
    * Connect device "eth5"
    * Delete connection "testeth5"
    * Connect device "eth5"
    * Connect device "eth5"
    * Connect device "eth5"
    Then "1" is visible with command "nmcli connection |grep ^eth5 |wc -l"


    @rhbz1498943
    @ver+=1.10
    @con_con_remove
    @double_connection_warning
    Scenario: nmcli - connection - warn about the same name
    * Add connection type "ethernet" named "con_con2" for device "eth5"
    Then "Warning: There is another connection with the name 'con_con2'. Reference the connection by its uuid" is visible with command "nmcli con add type ethernet ifname eth con-name con_con2"


    @rhbz997998
    @con_con_remove
    @connection_restricted_to_single_device
    Scenario: nmcli - connection - restriction to single device
     * Add connection type "ethernet" named "con_con" for device "*"
     * Start generic connection "con_con" for "eth5"
     * Start generic connection "con_con" for "eth6"
    Then "eth6" is visible with command "nmcli -f GENERAL.DEVICES connection show con_con"
    Then "eth5" is not visible with command "nmcli -f GENERAL.DEVICES connection show con_con"


    @rhbz1094296
    @con_con_remove @time
    @connection_secondaries_restricted_to_vpn
    Scenario: nmcli - connection - restriction to single device
     * Add connection type "ethernet" named "con_con" for device "*"
     * Add connection type "ethernet" named "time" for device "time"
     * Open editor for connection "con_con"
     * Submit "set connection.secondaries time" in editor
    Then Error type "is not a VPN connection profile" shown in editor


    @rhbz1108167
    @CCC
    @connection_removal_of_disapperared_device
    Scenario: nmcli - connection - remove connection of nonexisting device
     * Finish "sudo ip link add name CCC type bridge"
     * Finish "ip link set dev CCC up"
     * Finish "ip addr add 192.168.201.3/24 dev CCC"
     When "CCC" is visible with command "nmcli -f NAME connection show --active" in "5" seconds
     * Finish "sudo ip link del CCC"
     Then "CCC" is not visible with command "nmcli -f NAME connection show --active" in "5" seconds


    @con_con_remove
    @connection_down
    Scenario: nmcli - connection - down
     * Add connection type "ethernet" named "con_con" for device "eth5"
     * Bring "up" connection "con_con"
     * Bring "down" connection "con_con"
     Then "con_con" is not visible with command "nmcli -f NAME connection show --active"


    @con_con_remove
    @connection_set_id
    Scenario: nmcli - connection - set id
     * Add connection type "ethernet" named "con_con" for device "blah"
     * Open editor for connection "con_con"
     * Submit "set connection.id after_rename" in editor
     * Save in editor
     * Quit editor
     #* Prompt is not running
     Then Open editor for connection "after_rename"
     * Quit editor
     * Delete connection "after_rename"


    @con_con_remove
    @connection_set_uuid_error
    Scenario: nmcli - connection - set uuid
     * Add connection type "ethernet" named "con_con" for device "blah"
     * Open editor for connection "con_con"
     * Submit "set connection.uuid 00000000-0000-0000-0000-000000000000" in editor
     Then Error type "uuid" shown in editor


    @con_con_remove
    @connection_set_interface-name
    Scenario: nmcli - connection - set interface-name
     * Add connection type "ethernet" named "con_con" for device "blah"
     * Open editor for connection "con_con"
     * Submit "set connection.interface-name eth6" in editor
     * Save in editor
     * Quit editor
     #When Prompt is not running
     * Bring "up" connection "con_con"
     Then Check if "con_con" is active connection


    @veth @con_con_remove @restart
    @connection_autoconnect_yes
    Scenario: nmcli - connection - set autoconnect on
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.autoconnect yes" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     * Disconnect device "eth6"
     * Reboot
     Then Check if "con_con" is active connection


    @rhbz1401515
    @ver+=1.10
    @con_con_remove
    @connection_autoconnect_yes_without_immediate_effects
    Scenario: nmcli - connection - set autoconnect on without autoconnecting
     * Add a new connection of type "ethernet" and options "con-name con_con2 ifname eth5 autoconnect no"
     When "con_con2" is visible with command "nmcli con"
     * Execute "python tmp/repro_1401515.py" without waiting for process to finish
     Then "yes" is visible with command "nmcli connection show con_con2 |grep autoconnect:" in "5" seconds
      And Check if "con_con2" is not active connection


    @con_con_remove
    @connection_autoconnect_warning
    Scenario: nmcli - connection - autoconnect warning while saving new
     * Open editor for new connection "con_con" type "ethernet"
     * Save in editor
     Then autoconnect warning is shown
     * Enter in editor
     * Quit editor


    @con_con_remove @restart
    @connection_autoconnect_no
    Scenario: nmcli - connection - set autoconnect off
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.autoconnect no" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     * Reboot
     Then Check if "con_con" is not active connection


    @ver+=1.7.1
    @con_con_remove @restart
    @ifcfg_parse_options_with_comment
    Scenario: ifcfg - connection - parse options with comments
     * Execute "echo 'DEVICE=eth5' >> /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Execute "echo 'NAME=con_con' >> /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Execute "echo 'BOOTPROTO=dhcp' >> /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Execute "echo 'ONBOOT=no  # foo' >> /etc/sysconfig/network-scripts/ifcfg-con_con"
     * Reload connections
     * Restart NM
     Then Check if "con_con" is not active connection


    @ver+=1.8.0
    @con_con_remove @con_con_remove @restart
    @ifcfg_compliant_with_kickstart
    Scenario: ifcfg - connection - pykickstart compliance
    * Append "UUID='8b4753fb-c562-4784-bfa7-f44dc6581e73'" to ifcfg file "con_con2"
    * Append "DNS1='192.0.2.1'" to ifcfg file "con_con2"
    * Append "IPADDR='192.0.2.2'" to ifcfg file "con_con2"
    * Append "GATEWAY='192.0.2.1'" to ifcfg file "con_con2"
    * Append "NETMASK='255.255.255.0'" to ifcfg file "con_con2"
    * Append "BOOTPROTO='static'" to ifcfg file "con_con2"
    * Append "DEVICE='eth5'" to ifcfg file "con_con2"
    * Append "ONBOOT='yes'" to ifcfg file "con_con2"
    * Append "IPV6INIT='yes'" to ifcfg file "con_con2"
    * Reload connections
    * Execute "nmcli con modify uuid 8b4753fb-c562-4784-bfa7-f44dc6581e73 connection.id con_con"
    * Restart NM
    When "activated" is visible with command "nmcli -g GENERAL.STATE con show con_con" in "20" seconds
    Then "192.0.2.2" is visible with command "ip a s eth5"
     And "UUID=8b4753fb-c562-4784-bfa7-f44dc6581e73" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "DNS1=192.0.2.1" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "IPADDR=192.0.2.2" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "GATEWAY=192.0.2.1" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "NETMASK=255.255.255.0" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "BOOTPROTO='static'" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "DEVICE=eth5" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "ONBOOT=yes" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"
     And "IPV6INIT=yes" is visible with command "cat /etc/sysconfig/network-scripts/ifcfg-con_con2"


     @rhbz1367737
     @ver+=1.4.0
     @con_con_remove
     @manual_connection_with_both_ips
     Scenario: nmcli - connection - add ipv4 ipv6 manual connection
     * Execute "nmcli connection add type ethernet con-name con_con ifname eth5 ipv4.method manual ipv4.addresses 1.1.1.1/24 ipv6.method manual ipv6.addresses 1::2/128"
     Then "con_con" is visible with command "nmcli con"


    @time
    @connection_timestamp
    Scenario: nmcli - connection - timestamp
     * Add connection type "ethernet" named "time" for device "blah"
     * Open editor for connection "time"
     * Submit "set connection.autoconnect no" in editor
     * Submit "set connection.interface-name eth6" in editor
     * Save in editor
     * Quit editor
     * Open editor for connection "time"
     When Check if object item "connection.timestamp:" has value "0" via print
     * Quit editor
     * Bring "up" connection "time"
     * Bring "down" connection "time"
     * Open editor for connection "time"
     Then Check if object item "connection.timestamp:" has value "current_time" via print
     * Quit editor
     * Delete connection "time"


    @con_con_remove
    @connection_readonly_timestamp
    Scenario: nmcli - connection - readonly timestamp
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.timestamp 1372338021" in editor
     Then Error type "timestamp" shown in editor
     When Quit editor


    @con_con_remove
    @connection_readonly_yes
    Scenario: nmcli - connection - readonly read-only
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.read-only yes" in editor
     Then Error type "read-only" shown in editor


    @con_con_remove
    @connection_readonly_type
    Scenario: nmcli - connection - readonly type
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.type 802-3-ethernet" in editor
     Then Error type "type" shown in editor


    @con_con_remove
    @connection_permission_to_user
    Scenario: nmcli - connection - permissions to user
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set connection.permissions test" in editor
     * Save in editor
     * Check if object item "connection.permissions:" has value "user:test" via print
     * Quit editor
     #* Prompt is not running
     * Bring "up" connection "con_con"
     * Open editor for connection "con_con"
    Then Check if object item "connection.permissions:" has value "user:test" via print
     * Quit editor
    Then "test" is visible with command "grep test /etc/sysconfig/network-scripts/ifcfg-con_con"


    @con_con_remove @firewall
    @connection_zone_drop_to_public
    Scenario: nmcli - connection - zone to drop and public
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     * Submit "set ipv4.method manual" in editor
     * Submit "set ipv4.addresses 192.168.122.253" in editor
     * Submit "set connection.zone drop" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     When "eth6" is visible with command "firewall-cmd --zone=drop --list-all"
     * Open editor for connection "con_con"
     * Submit "set connection.zone" in editor
     * Enter in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     Then "eth6" is visible with command "firewall-cmd --zone=public --list-all"


     @rhbz1366288
     @ver+=1.4.0
     @con_con_remove @firewall @restart
     @firewall_zones_restart_persistence
     Scenario: nmcli - connection - zone to drop and public
      * Add connection type "ethernet" named "con_con" for device "eth5"
      When "public\s+interfaces: eth0 eth5" is visible with command "firewall-cmd --get-active-zones"
      * Execute "nmcli c modify con_con connection.zone internal"
      When "internal\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"
      * Execute "systemctl restart firewalld"
      When "internal\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"
      * Restart NM
      When "internal\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"
      * Execute "nmcli c modify con_con connection.zone home"
      When "home\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"
      * Execute "systemctl restart firewalld"
      When "home\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"
      * Execute "nmcli c modify con_con connection.zone work"
      Then "work\s+interfaces: eth5" is visible with command "firewall-cmd --get-active-zones"
       And "public\s+interfaces: eth0" is visible with command "firewall-cmd --get-active-zones"


    @rhbz663730
    @veth @con_con_remove @con_con_remove @restart
    @profile_priorities
    Scenario: nmcli - connection - profile priorities
     * Add connection type "ethernet" named "con_con2" for device "eth6"
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Execute "nmcli con modify con_con2 connection.autoconnect-priority 2"
     * Execute "nmcli con modify con_con connection.autoconnect-priority 1"
     * Bring "up" connection "con_con2"
     * Bring "up" connection "con_con"
     * Disconnect device "eth6"
     * Restart NM
     Then "con_con2" is visible with command "nmcli con show -a"


    # NM_METERED_UNKNOWN    = 0,
    # NM_METERED_YES        = 1,
    # NM_METERED_NO         = 2,
    # NM_METERED_GUESS_YES  = 3,
    # NM_METERED_GUESS_NO   = 4,


    @rhbz1200452
    @con_con_remove @eth0
    @connection_metered_manual_yes
    Scenario: nmcli - connection - metered manual yes
     * Add connection type "ethernet" named "con_con" for device "eth5"
     * Open editor for connection "con_con"
     * Submit "set connection.metered true" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     Then Metered status is "1"


    @rhbz1200452
    @con_con_remove @eth0
    @connection_metered_manual_no
    Scenario: nmcli - connection - metered manual no
     * Add connection type "ethernet" named "con_con" for device "eth5"
     * Open editor for connection "con_con"
     * Submit "set connection.metered false" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     Then Metered status is "2"


    @rhbz1200452
    @con_con_remove @eth0
    @connection_metered_guess_no
    Scenario: NM - connection - metered guess no
     * Add connection type "ethernet" named "con_con" for device "eth5"
     * Open editor for connection "con_con"
     * Submit "set connection.metered unknown" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     Then Metered status is "4"


    @rhbz1200452
    @con_con_remove @eth0
    @teardown_testveth
    @connection_metered_guess_yes
    Scenario: NM - connection - metered guess yes
     * Prepare simulated test "testX" device with "192.168.99" ipv4 and "2620:52:0:dead" ipv6 dhcp address prefix and dhcp option "43,ANDROID_METERED"
     * Add a new connection of type "ethernet" and options "ifname testX con-name con_con autoconnect off"
     * Open editor for connection "con_con"
     * Submit "set ipv6.method ignore" in editor
     * Submit "set connection.metered unknown" in editor
     * Save in editor
     * Quit editor
     * Bring "up" connection "con_con"
     Then Metered status is "3"


     @con_con_remove @long
     @display_allowed_values
     Scenario: nmcli - connection - showing allowed values
     * Add connection type "ethernet" named "con_con" for device "testX"
     * Open editor for connection "con_con"
     * Check "fast|leap|md5|peap|pwd|sim|tls|ttls" are shown for object "802-1x.eap"
     * Check "0|1" are shown for object "802-1x.phase1-peapver"
     * Check "0|1" are shown for object "802-1x.phase1-peaplabel"
     * Check "0|1|2|3" are shown for object "802-1x.phase1-fast-provisioning"
     * Check "chap|gtc|md5|mschap|mschapv2|otp|pap|tls" are shown for object "802-1x.phase2-auth"
     * Check "gtc|md5|mschapv2|otp|tls" are shown for object "802-1x.phase2-autheap"
     * Check "fabric|vn2vn" are shown for object "dcb.app-fcoe-mode"
     * Check "auto|disabled|link-local|manual|shared" are shown for object "ipv4.method"
     * Check "auto|dhcp|ignore|link-local|manual|shared" are shown for object "ipv6.method"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.ca-cert"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.ca-path"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.private-key"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.phase2-ca-cert"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.phase2-ca-path"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "802-1x.phase2-private-key"
     * Check "broadcast_mode|ctcprot|ipato_add4|ipato_invert6|layer2|protocol|rxip_add6|vipa_add6|buffer_count|fake_broadcast|ipato_add6|isolation|portname|route4|sniffer|canonical_macaddr|inter|ipato_enable|lancmd_timeout|portno|route6|total|checksumming|inter_jumbo|ipato_invert4|large_send|priority_queueing|rxip_add4|vipa_add4" are shown for object "ethernet.s390-options"
     * Check "ctc|lcs|qeth" are shown for object "ethernet.s390-nettype"
     * Check "bond|bridge|team" are shown for object "connection.slave-type"
     * Quit editor
     * Add connection type "bond" named "con-bond" for device "con-bond0"
     * Open editor for connection "con-bond"
     * Check "ad_select|arp_ip_target|downdelay|lacp_rate|mode|primary_reselect|updelay|xmit_hash_policy|arp_interval|arp_validate|fail_over_mac|miimon|primary|resend_igmp|use_carrier|" are shown for object "bond.options"
     * Quit editor
     * Add connection type "team" named "con-team" for device "con-team0"
     * Open editor for connection "con-team"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "team.config"
     * Check "testmapper.txt|nmcli|nmtui|README|prepare" are shown for object "team-port.config"
     * Quit editor
     * Add a new connection of type "wifi" and options "ifname wifi con-name con-wifi autoconnect off ssid con-wifi"
     * Open editor for connection "con-wifi"
     * Check "adhoc|ap|infrastructure" are shown for object "wifi.mode"
     * Check "a|bg" are shown for object "wifi.band"
     * Check "ieee8021x|none|wpa-eap|wpa-none|wpa-psk\s+" are shown for object "wifi-sec.key-mgmt"
     * Check "leap|open|shared" are shown for object "wifi-sec.auth-alg"
     * Check "rsn|wpa" are shown for object "wifi-sec.proto"
     * Check "ccmp|tkip" are shown for object "wifi-sec.pairwise"
     * Check "ccmp|tkip|wep104|wep40" are shown for object "wifi-sec.group"
     * Quit editor
     * Add connection type "infiniband" named "con_con2" for device "mlx4_ib1"
     * Open editor for connection "con_con2"
     * Check "connected|datagram" are shown for object "infiniband.transport-mode"
     * Quit editor


    @rhbz1142898
    @ver+=1.4.0
    @con_con_remove @teardown_testveth
    @lldp
    Scenario: nmcli - connection - lldp
     * Prepare simulated test "testX" device
     * Add a new connection of type "ethernet" and options "ifname testX con-name con_con ipv4.method manual ipv4.addresses 1.2.3.4/24 connection.lldp enable"
     * Bring "up" connection "con_con"
     When "testX\s+ethernet\s+connected" is visible with command "nmcli device" in "5" seconds
     * Execute "ip netns exec testX_ns tcpreplay --intf1=testXp tmp/lldp.detailed.pcap"
     Then "NEIGHBOR\[0\].DEVICE:\s+testX" is visible with command "nmcli device lldp" in "5" seconds
      And "NEIGHBOR\[0\].CHASSIS-ID:\s+00:01:30:F9:AD:A0" is visible with command "nmcli device lldp"
      And "NEIGHBOR\[0\].PORT-ID:\s+1\/1" is visible with command "nmcli device lldp"
      And "NEIGHBOR\[0\].PORT-DESCRIPTION:\s+Summit300-48-Port 1001" is visible with command "nmcli device lldp"
      And "NEIGHBOR\[0\].SYSTEM-NAME:\s+Summit300-48" is visible with command "nmcli device lldp"
      And "NEIGHBOR\[0\].SYSTEM-DESCRIPTION:\s+Summit300-48 - Version 7.4e.1 \(Build 5\) by Release_Master 05\/27\/05 04:53:11" is visible with command "nmcli device lldp"
      And "NEIGHBOR\[0\].SYSTEM-CAPABILITIES:\s+20 \(mac-bridge,router\)" is visible with command "nmcli device lldp"


    @rhbz1417292
    @eth5_disconnect
    @introspection_active_connection
    Scenario: introspection - check active connections
     * Execute "python tmp/network_test.py testeth5 > /tmp/test"
     When "testeth5" is visible with command "nmcli con s -a"
     Then "Active connections before: 1" is visible with command "cat /tmp/test"
      And "Active connections after: 2.*Active connections after: 2" is visible with command "cat /tmp/test"


    @rhbz1421429
    @ver+=1.8.0
    @con_con_remove
    @connection_user_settings_data
    Scenario: NM - connection - user settings data
    * Add a new connection of type "ethernet" and options "ifname testX con-name con_con autoconnect no"
    * Execute "python tmp/setting-user-data.py set id con_con my.own.data good_morning_starshine"
    * Execute "python tmp/setting-user-data.py set id con_con my.own.data.two the_moon_says_hello"
    When "good_morning_starshine" is visible with command "python tmp/setting-user-data.py get id con_con my.own.data"
     And "the_moon_says_hello" is visible with command "python tmp/setting-user-data.py get id con_con my.own.data.two"
    * Execute "python tmp/setting-user-data.py set id con_con -d my.own.data"
    * Execute "python tmp/setting-user-data.py set id con_con -d my.own.data.two"
    Then "[none]|[0]" is visible with command "python tmp/setting-user-data.py id con_con"
     And "\"my.own.data\" = \"good_morning_starshine\"|\"my.own.data.two\" = \"the_moon_says_hello\"" is not visible with command "python tmp/setting-user-data.py id con_con" in "5" seconds


    @rhbz1448165
    @eth5_disconnect
    @connection_track_external_changes
    Scenario: NM - connection - track external changes
     * Execute "ip add add 192.168.1.2/24 dev eth5"
    Then "192.168.1.2/24" is visible with command "nmcli con sh eth5 |grep IP4" in "2" seconds


    @con_con_remove
    @connection_describe
    Scenario: nmcli - connection - describe
     * Add connection type "ethernet" named "con_con" for device "eth6"
     * Open editor for connection "con_con"
     Then Check "\[id\]|\[uuid\]|\[interface-name\]|\[type\]" are present in describe output for object "connection"
     * Submit "goto connection" in editor

     Then Check "=== \[id\] ===\s+\[NM property description\]\s+A human readable unique identifier for the connection, like \"Work Wi-Fi\" or \"T-Mobile 3G\"." are present in describe output for object "id"

     Then Check "=== \[uuid\] ===\s+\[NM property description\]\s+A universally unique identifier for the connection, for example generated with libuuid.  It should be assigned when the connection is created, and never changed as long as the connection still applies to the same network.  For example, it should not be changed when the \"id\" property or NMSettingIP4Config changes, but might need to be re-created when the Wi-Fi SSID, mobile broadband network provider, or \"type\" property changes. The UUID must be in the format \"2815492f-7e56-435e-b2e9-246bd7cdc664\" \(ie, contains only hexadecimal characters and \"-\"\)." are present in describe output for object "uuid"

     Then Check "=== \[interface-name\] ===\s+\[NM property description\]\s+The name of the network interface this connection is bound to. If not set, then the connection can be attached to any interface of the appropriate type \(subject to restrictions imposed by other settings\). For software devices this specifies the name of the created device. For connection types where interface names cannot easily be made persistent \(e.g. mobile broadband or USB Ethernet\), this property should not be used. Setting this property restricts the interfaces a connection can be used with, and if interface names change or are reordered the connection may be applied to the wrong interface." are present in describe output for object "interface-name"

     Then Check "=== \[type\] ===\s+\[NM property description\]\s+Base type of the connection. For hardware-dependent connections, should contain the setting name of the hardware-type specific setting \(ie, \"802\-3\-ethernet\" or \"802\-11\-wireless\" or \"bluetooth\", etc\), and for non-hardware dependent connections like VPN or otherwise, should contain the setting name of that setting type \(ie, \"vpn\" or \"bridge\", etc\)." are present in describe output for object "type"

     Then Check "=== \[autoconnect\] ===\s+\[NM property description\]\s+Whether or not the connection should be automatically connected by NetworkManager when the resources for the connection are available. TRUE to automatically activate the connection, FALSE to require manual intervention to activate the connection." are present in describe output for object "autoconnect"

     Then Check "=== \[timestamp\] ===\s+\[NM property description\]\s+The time, in seconds since the Unix Epoch, that the connection was last _successfully_ fully activated. NetworkManager updates the connection timestamp periodically when the connection is active to ensure that an active connection has the latest timestamp. The property is only meant for reading \(changes to this property will not be preserved\)." are present in describe output for object "timestamp"

     Then Check "=== \[read-only\] ===\s+\[NM property description\]\s+FALSE if the connection can be modified using the provided settings service's D-Bus interface with the right privileges, or TRUE if the connection is read-only and cannot be modified." are present in describe output for object "read-only"

     Then Check "=== \[zone\] ===\s+\[NM property description\]\s+The trust level of a the connection.  Free form case-insensitive string \(for example \"Home\", \"Work\", \"Public\"\).  NULL or unspecified zone means the connection will be placed in the default zone as defined by the firewall." are present in describe output for object "zone"

     Then Check "=== \[master\] ===\s+\[NM property description\]\s+Interface name of the master device or UUID of the master connection" are present in describe output for object "master"

     Then Check "=== \[slave-type\] ===\s+\[NM property description\]\s+Setting name of the device type of this slave's master connection \(eg, \"bond\"\), or NULL if this connection is not a slave." are present in describe output for object "slave-type"

     Then Check "=== \[secondaries\] ===\s+\[NM property description\]\s+List of connection UUIDs that should be activated when the base connection itself is activated. Currently only VPN connections are supported." are present in describe output for object "secondaries"

     Then Check "=== \[gateway-ping-timeout\] ===\s+\[NM property description]\s+If greater than zero, delay success of IP addressing until either the timeout is reached, or an IP gateway replies to a ping." are present in describe output for object "gateway-ping-timeout"


    @ver+=1.14
    @con_con_remove
    @connection_multiconnect_default_single
    Scenario: nmcli - connection - multi-connect default or single
    * Add a new connection of type "ethernet" and options "con-name con_con autoconnect no ifname '' connection.multi-connect default"
    * Bring up connection "con_con" for "eth5" device
    When "eth5" is visible with command "nmcli device | grep con_con"
    * Bring up connection "con_con" for "eth6" device
    When "eth6" is visible with command "nmcli device | grep con_con"
     And "eth5" is not visible with command "nmcli device | grep con_con"
    * Bring "down" connection "con_con"
    * Modify connection "con_con" changing options "connection.multi-connect single"
    * Bring up connection "con_con" for "eth5" device
    When "eth5" is visible with command "nmcli device | grep con_con"
    * Bring up connection "con_con" for "eth6" device
    Then "eth6" is visible with command "nmcli device | grep con_con"
     And "eth5" is not visible with command "nmcli device | grep con_con"


    @ver+=1.14
    @con_con_remove
    @connection_multiconnect_manual
    Scenario: nmcli - connection - multi-connect manual up down
    * Add a new connection of type "ethernet" and options "con-name con_con autoconnect no ifname '' connection.multi-connect manual-multiple"
    * Bring up connection "con_con" for "eth5" device
    When "eth5" is visible with command "nmcli device | grep con_con"
     And "eth6" is not visible with command "nmcli device | grep con_con"
    * Bring up connection "con_con" for "eth6" device
    When "eth6" is visible with command "nmcli device | grep con_con"
     And "eth5" is visible with command "nmcli device | grep con_con"
    * Bring "down" connection "con_con"
    When "eth6" is not visible with command "nmcli device | grep con_con"
     And "eth5" is not visible with command "nmcli device | grep con_con"
    * Modify connection "con_con" changing options "connection.multi-connect multiple"
    * Bring up connection "con_con" for "eth5" device
    When "eth5" is visible with command "nmcli device | grep con_con"
     And "eth6" is not visible with command "nmcli device | grep con_con"
    * Bring up connection "con_con" for "eth6" device
    When "eth6" is visible with command "nmcli device | grep con_con"
     And "eth5" is visible with command "nmcli device | grep con_con"
    * Bring "down" connection "con_con"
    Then "eth6" is not visible with command "nmcli device | grep con_con"
     And "eth5" is not visible with command "nmcli device | grep con_con"


    @ver+=1.14
    @con_con_remove @restart
    @connection_multiconnect_autoconnect
    Scenario: nmcli - connection - multi-connect with autoconnect
    * Add a new connection of type "ethernet" and options "con-name con_con connection.autoconnect yes connection.autoconnect-priority 0 ifname '' connection.multi-connect manual-multiple"
    When "eth5" is not visible with command "nmcli device | grep con_con"
     And "eth6" is not visible with command "nmcli device | grep con_con"
    * Add a new connection of type "ethernet" and options "con-name con_con2 connection.autoconnect yes connection.autoconnect-priority 0 ifname '' connection.multi-connect multiple"
    When "eth5" is visible with command "nmcli device | grep con_con2"
     And "eth6" is visible with command "nmcli device | grep con_con2"
    * Bring "down" connection "con_con2"
    Then "eth6" is not visible with command "nmcli device | grep con_con2"
     And "eth5" is not visible with command "nmcli device | grep con_con2"


    @ver+=1.14
    @con_con_remove @restart
    @connection_multiconnect_reboot
    Scenario: nmcli - connection - multi-connect reboot
    * Add a new connection of type "ethernet" and options "con-name con_con connection.autoconnect yes connection.autoconnect-priority 0 ifname '' connection.multi-connect multiple match.interface-name '!eth0'"
    * Reboot
    Then "eth0" is not visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth1" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth2" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth3" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth4" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth5" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth6" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth7" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth8" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth9" is visible with command "nmcli device | grep ethernet | grep con_con"
     And "eth10" is visible with command "nmcli device | grep ethernet | grep con_con"


    @rhbz1639254
    @ver+=1.14
    @con_con_remove @unmanage_eth @skip_str
    @connection_prefers_managed_devices
    Scenario: nmcli - connection - connection activates preferably on managed devices
    * Execute "nmcli device set eth10 managed yes"
    * Add a new connection of type "ethernet" and options "ifname \* con-name con_con autoconnect no"
    * Bring up connection "con_con"
    Then "eth10" is visible with command "nmcli device | grep con_con"


    @rhbz1639254
    @ver+=1.14
    @con_con_remove @unmanage_eth @skip_str
    @connection_no_managed_device
    Scenario: nmcli - connection - connection activates even on unmanaged device
    * Add a new connection of type "ethernet" and options "ifname \* con-name con_con autoconnect no"
    * Bring up connection "con_con"
    Then "con_con" is visible with command "nmcli device"


    @rhbz1434527
    @ver+=1.14
    @con_con_remove
    @connection_short_info
    Scenario: nmcli - connection - connection short info
    * Add a new connection of type "ethernet" and options "ifname \* con-name con_con autoconnect no"
    * Note the output of "nmcli -o con show con_con"
    Then Check noted output contains "connection.id"
    Then Check noted output does not contain "connection.zone"
    * Note the output of "nmcli con show con_con"
    Then Check noted output contains "connection.id"
    Then Check noted output contains "connection.zone"
