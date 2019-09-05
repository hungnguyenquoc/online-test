using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models.Response
{
    public class BaseResponse
    {
        public int ErrorCode { get; set; } = 0;
        public string Message { get; set; } = "";
        public object Data { get; set; }
    }
}
