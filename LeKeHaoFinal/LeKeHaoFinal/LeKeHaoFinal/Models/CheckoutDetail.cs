using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace LeKeHaoFinal.Models
{
    [Table("CHECKOUTDETAILS")]
    public class CheckoutDetail
    {
        [Key]
        public long CHKD_ID { get; set; }

        public long CHK_ID { get; set; }
        [ForeignKey("CHK_ID")]
        public virtual Checkout Checkout { get; set; }

        public long BOO_ID { get; set; }
        [ForeignKey("BOO_ID")]
        public virtual Book Book { get; set; }

        public DateTime CHECKOUTDATE { get; set; }
        public int CHECKOUTBY { get; set; }

        public DateTime CHECKINDATE { get; set; }
        public int CHECKINBY { get; set; }



       
    }
}
