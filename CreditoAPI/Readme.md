# Processamento de Crédito API

Esta API em .NET Core foi desenvolvida para processamento de solicitações de crédito com diferentes tipos, aplicando regras de validação e retorno de informações sobre o crédito.

## Funcionalidades

- Recebe solicitações de crédito com os seguintes dados:
  - Valor do crédito.
  - Tipo de crédito (Crédito Direto, Crédito Consignado, Crédito Pessoa Jurídica, Crédito Pessoa Física, Crédito Imobiliário).
  - Quantidade de parcelas.
  - Data do primeiro vencimento.

- Realiza validações conforme as seguintes regras:
  - O valor máximo a ser liberado para qualquer tipo de empréstimo é de R$ 1.000.000,00.
  - A quantidade mínima de parcelas é de 5x e máxima de 72x.
  - Para o crédito de pessoa jurídica, o valor mínimo a ser liberado é de R$ 15.000,00.
  - A data do primeiro vencimento deve estar entre 15 e 40 dias a partir da data atual.

- Retorna informações sobre o crédito processado:
  - Status do crédito (Aprovado ou Recusado).
  - Valor total com juros.
  - Valor dos juros.

## Configuração e Uso

1. **Requisitos:**
   - .NET Core SDK7
   - Postman (ou outra ferramenta para testar APIs)

2. **Executando a aplicação:**
   - Clone este repositório.
   - No terminal, navegue até o diretório do projeto.
   - Execute o comando `dotnet run` para iniciar a aplicação.

3. **Testando a API:**
   - Use o Postman ou uma ferramenta similar.
   - Envie requisições POST para `https://localhost:<porta>/api/Credito/processar` com os dados do crédito no corpo da requisição no formato JSON.

   exemplo:

  {
    "Valor": 20000,
    "Tipo": 2,
    "QuantidadeParcelas": 12,
    "DataPrimeiroVencimento": "2023-12-25"
  }


## Estrutura do Projeto

### CreditoController

- **Responsabilidade:** Receber as solicitações de crédito e processá-las.
- **Funcionalidade:** Valida os dados recebidos, aplica as regras de negócio para processamento do crédito e retorna as informações sobre o crédito processado.

### Credito

- **Responsabilidade:** Representar os dados de crédito recebidos na solicitação.
- **Funcionalidade:** Possui os campos necessários para o processamento do crédito, como valor, tipo, quantidade de parcelas e data do primeiro vencimento. Inclui as validações dos dados de entrada.

### ProcessamentoCredito

- **Responsabilidade:** Realizar o cálculo da taxa de juros e efetuar validações adicionais (caso necessário).
- **Funcionalidade:** Contém métodos para calcular a taxa de juros com base no tipo de crédito e realizar validações extras, caso sejam necessárias no processamento do crédito.
