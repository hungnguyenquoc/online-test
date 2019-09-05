using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models
{
    [Table("TITLES")]
    public class Title
    {
        [Key]
        public int TIT_ID { get; set; }

        public string TITLE { get; set; }
 
        public int PUBLISHINGYEAR { get; set; }

        public string PUBLISHER { get; set; }
        public string AUTHOR { get; set; }
        public string DESCRIPTION { get; set; }
    
        public DateTime CREATEDDATE { get; set; }

        public int CREATEDBY { get; set; }
    }
}
