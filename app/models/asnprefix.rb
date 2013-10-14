class Asnprefix < ActiveRecord::Base
	self.table_name = 'pfx2asn'
	has_many :servers, primary_key: :asn, foreign_key: :asn
	def self.by_ip(ip)
		find_by_sql("SELECT pfx, asn FROM pfx2asn WHERE pfx >>= ip4r('%s') ORDER BY ip4r_size(pfx) LIMIT 1" % ip)
	end
end
