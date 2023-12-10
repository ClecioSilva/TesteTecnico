using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CreditoAPI
{
    public class ProcessamentoCredito
    {
        public decimal CalcularTaxa(Credito credito)
        {
        switch (credito.Tipo)
        {
            case TipoCredito.Direto:
                return credito.Valor * 0.02m;
            case TipoCredito.Consignado:
                return credito.Valor * 0.01m;
            case TipoCredito.PessoaJuridica:
                return credito.Valor * 0.05m;
            case TipoCredito.PessoaFisica:
                return credito.Valor * 0.03m;
            case TipoCredito.Imobiliario:
                return credito.Valor * 0.09m;
            default:
                throw new ArgumentException("Tipo de crédito inválido");
        }
    }

    public bool ValidarCredito(Credito credito)
    {
        // Adicione aqui suas regras de validação, se necessário
        return true;
    }
}
}