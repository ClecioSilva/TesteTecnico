using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace CreditoAPI
{
    public class Credito
    {
        [Required(ErrorMessage = "O campo Valor é obrigatório.")]
        [Range(1, 1000000, ErrorMessage = "O valor deve ser entre R$ 1,00 e R$ 1.000.000,00.")]
        public decimal Valor { get; set; }

        [Required(ErrorMessage = "O campo Tipo é obrigatório.")]
        public TipoCredito Tipo { get; set; }

        [Required(ErrorMessage = "O campo Quantidade de Parcelas é obrigatório.")]
        [Range(5, 72, ErrorMessage = "A quantidade de parcelas deve ser entre 5 e 72.")]
        public int QuantidadeParcelas { get; set; }

        [Required(ErrorMessage = "O campo Data do Primeiro Vencimento é obrigatório.")]
        [DataType(DataType.Date, ErrorMessage = "O campo Data do Primeiro Vencimento deve ser uma data válida.")]
        public DateTime DataPrimeiroVencimento { get; set; }
    }
}