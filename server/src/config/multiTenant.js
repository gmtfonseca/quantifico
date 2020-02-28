module.exports = {
  /**
   * The name of the tenant id field. Default: tenantId
   */
  tenantIdKey: 'organizacao',

  /**
   * The name of the tenant id getter method. Default: getTenantId
   */
  tenantIdGetter: 'getOrganizacaoId',

  /**
   * The name of the tenant bound model getter method. Default: byTenant
   */
  accessorMethod: 'byOrganizacao'

  /**
   * Enforce tenantId field to be set. Default: false
   * NOTE: this option will become enabled by default in mongo-tenant@2.0
   */
  // requireTenantId: true
}
