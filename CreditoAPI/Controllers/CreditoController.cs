using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace CreditoAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CreditoController : ControllerBase
    {
        // ... outros métodos

    [HttpPost("processar")]
    public ActionResult<object> ProcessarCredito([FromBody] Credito credito)
    {
        if (!ModelState.IsValid)
        {
            return BadRequest(ModelState);
        }

        DateTime dataAtual = DateTime.Now.Date;
        DateTime minDataVencimento = dataAtual.AddDays(15);
        DateTime maxDataVencimento = dataAtual.AddDays(40);

        string statusCredito = "Aprovado"; // Inicializa com o status "Aprovado"

        if (credito.Valor > 1000000 ||
            credito.QuantidadeParcelas < 5 || credito.QuantidadeParcelas > 72 ||
            (credito.Tipo == TipoCredito.PessoaJuridica && credito.Valor < 15000) ||
            credito.DataPrimeiroVencimento < minDataVencimento || credito.DataPrimeiroVencimento > maxDataVencimento)
        {
            statusCredito = "Recusado"; // Altera o status para "Recusado" se alguma validação falhar
        }

        if (credito.DataPrimeiroVencimento < minDataVencimento || credito.DataPrimeiroVencimento > maxDataVencimento)
        {
            return BadRequest("A Data do Primeiro Vencimento deve estar entre 15 e 40 dias a partir da data atual.");
        }

        if (credito.QuantidadeParcelas < 5 || credito.QuantidadeParcelas > 72)
        {
            return BadRequest("A quantidade de parcelas deve ser entre 5 e 72.");
        }

        if (credito.Tipo == TipoCredito.PessoaJuridica && credito.Valor < 15000)
        {
            return BadRequest("O valor mínimo a ser liberado para Pessoa Jurídica é de R$ 15.000,00.");
        }

        if (credito.Valor > 1000000)
        {
            return BadRequest("O valor máximo permitido para qualquer tipo de empréstimo é de R$ 1.000.000,00.");
        }

        decimal taxaJuros = 0;

        switch (credito.Tipo)
        {
            case TipoCredito.Direto:
                taxaJuros = 0.02m;
                break;
            case TipoCredito.Consignado:
                taxaJuros = 0.01m;
                break;
            case TipoCredito.PessoaJuridica:
                taxaJuros = 0.05m;
                break;
            case TipoCredito.PessoaFisica:
                taxaJuros = 0.03m;
                break;
            case TipoCredito.Imobiliario:
                taxaJuros = 0.09m;
                break;
            default:
                return BadRequest("Tipo de crédito inválido.");
        }

        decimal valorJuros = credito.Valor * taxaJuros;
        decimal valorTotalComJuros = credito.Valor + valorJuros;
            if (credito.Valor > 1000000 || (credito.Tipo == TipoCredito.PessoaJuridica && credito.Valor < 15000) || 
            credito.QuantidadeParcelas < 5 || credito.QuantidadeParcelas > 72 || 
            credito.DataPrimeiroVencimento < minDataVencimento || credito.DataPrimeiroVencimento > maxDataVencimento)
        {
            statusCredito = "Recusado";
        }

        var resultado = new
        {
            StatusCredito = statusCredito,
            ValorTotalComJuros = valorTotalComJuros,
            ValorJuros = valorJuros
        };

        return Ok(resultado);
    }
}
}