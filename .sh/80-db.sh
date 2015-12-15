# Shell runtime configuration | database interaction

# NOTE: disabled because it breaks 'mysql -e'
#alias mysql="expect <(echo 'spawn -noecho mysql {*}\$argv
#                            set timeout 12
#                            expect {
#                                mysql> {
#                                    set timeout 6
#                                    send \"SET autocommit = 0;\r\"
#                                    expect mysql> {
#                                        send [concat \
#                                                  SET \
#                                                  TRANSACTION ISOLATION LEVEL \
#                                                  READ COMMITTED\;]
#                                        send \"\r\"
#                                    }
#                                    interact
#                                }
#                                -nocase \"enter password:\" {
#                                    set timeout 6
#                                    stty -echo
#                                    expect_user -timeout -1 -re \"(.*)\n\"
#                                    stty echo
#                                    send \"\$expect_out(1,string)\r\"
#                                    exp_continue
#                                }
#                                -nocase error {exit 1}
#                                eof {exit 1}
#                                timeout {
#                                    send_user [concat \
#                                                   error: mysql took longer \
#                                                   than \$timeout second(s) \
#                                                   to start]\n
#                                    exit 1
#                                }
#                            }') \
#                    -- --i-am-a-dummy"
