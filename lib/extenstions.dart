extension s on String{
  toSentenceCase(){
    return ((this??"")!="")?
     this.substring(0,1).toUpperCase()+ this.substring(1):
    this;
  }
}
