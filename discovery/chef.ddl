metadata    :name        => "chef",
            :description => "Discovery node identities using the Chef server",
            :author      => "Zachary Stevens <zts@cryptocracy.com>",
            :license     => "ASL 2.0",
            :version     => "0.1",
            :url         => "http://github.com/zts/",
            :timeout     => 0

discovery do
    capabilities :classes, :identity
end
