require [ "fileinto", "regex" ];

###################
# Spam processing #
###################

# I use this rule so that anything that is at least 94% certain spam
# gets discarded.  You might want to enable this rule after you are
# comfortable
#
# if header :regex "X-Spambayes-Classification" "spam; (1|0\\.9[4-9])*"
# {
#    discard;
#    stop;
# }
# elsif 

if header :matches "X-Spambayes-Classification" "spam;*"
{
    # This stuff is almost certainly spam, but as a safety net we keep it around
    # for a while, just in case.  Do not confuse this folder with the
    # one called "training.spam," which holds the spam training set.  
    fileinto "filtered.spam";
    stop;
}
elsif header :matches "X-Spambayes-Classification" "unsure;*"
{
    # These are messages we'll want to train on once we figure out if
    # they're ham or spam, by copying or moving them into the
    # folders for their respective training sets
    fileinto "filtered.unsure";
    stop;
}

# Everything else goes into INBOX.  Much more sophisticated stuff is
# possible; ask if you care.
